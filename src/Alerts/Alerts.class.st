"
An Alerts is a framework that allow you to generate  violations on  some good programing rules according to SmallLint .

Instance Variables
	alerts:		is a collection of all methodproperties of a package. a methodproperties  contains for each method a set of rules violated for examples, messages, literals and pragmas.
	directory:		is the path were we can find commit (mc files) of source code
	packageName:		since we can have differents packages comits in directory this represent the actual package we studies
	packages:		represent all the commits of a same actual package that we select in repository
			=======================
The main method is:
setWithDirectory: : this method set the directory where are located commits and collects packages.

run : this method use gofer to load a version of a package, collect rule violation on it and compare with the previous version to collect corrected warnings in a ACompositeCWarning.

==========================================
to have a try you can execute this
-----------------------------------------------
|a|
a:=Alerts new.
a getAllCorrectedWarningsFrom: aPath.

or
|a|
a:=Alerts new. 
a getAllAddedWarningsFrom: aPath.

or 
|a|
a:=Alerts new.
a getAllDeletedWarningsFrom: aPath
--------------------------------------------------
this will give you a ACompositeCWarning containing all corrected warning among differents versions of packages.
"
Class {
	#name : #Alerts,
	#superclass : #Object,
	#instVars : [
		'alerts',
		'directory',
		'packageName',
		'packages',
		'packageHistory',
		'correctedWarns'
	],
	#category : #Alerts
}

{ #category : #'as yet unclassified' }
Alerts class >> deplacementFichier [
	| directory packages |
	directory := '/home/hayatou/Bureau/mooseSource' asFileReference.
	packages := directory files
		do: [ :e | 
			| ref |
			ref := (e parent asFileReference / (e basename copyUpToLast: $-)) asFileReference.
			ref ensureCreateDirectory.
			e moveTo: (ref asFileReference / e basename) asFileReference ]
]

{ #category : #'as yet unclassified' }
Alerts class >> forPharoImage [
|allPack csv fileName|
allPack := OrderedCollection new.
fileName  :=String new.
fileName  := (Smalltalk version asString ), '.csv'.
csv := Alerts new.
PackageInfo allPackages do: [ :e | |ac| 
	ac:=Alerts new.
	ac collectDataForPackage: (e packageName ).
	allPack addAll: ac alerts.
	].
csv alerts: allPack.
csv generateCSVinFileNamed: fileName.

]

{ #category : #'as yet unclassified' }
Alerts class >> suppressionFichier [
	| directory packages version|
	directory := '/home/oumarou/Desktop/seasidePh3/seasidesource/seaside3/Seaside-Core' asFileReference.
	packages := directory files
		do: [ :e | 
			|  |
			((e basenameWithoutExtension copyAfterLast: $.) asInteger <= version ) ifTrue:[e delete]  ].
]

{ #category : #running }
Alerts >> addAlert: anAlert [
	"Add a warning aCSVWarning in the instance variable warnings"
	self alerts add: anAlert .
]

{ #category : #accessing }
Alerts >> alerts [
	^ alerts
]

{ #category : #accessing }
Alerts >> alerts: anObject [
	alerts := anObject
]

{ #category : #gofer }
Alerts >> clean [
	"Unload a package named packageName from the system"

	Gofer new
		directory: self directory;
		package: self packageName;
		disablePackageCache;
		disableRepositoryErrors;
		unload

]

{ #category : #running }
Alerts >> collectDataForPackage: aPackage [
	"generate for each method in aPackage rules violated, messages, variables and pragmas"

	| aSmallLint aCompMth result |
	result := Set new.
	aSmallLint := ASmallLint new.
	aCompMth := ACompositeMethodProperties new.
	aSmallLint warningsFor: aPackage.
	aCompMth forPackage: aPackage.
	packageHistory setPackageHistory: aPackage.
	aSmallLint rules leaves
		do: [ :cri | 
			packageHistory currentViolationsHistory at: cri class asString put: cri problemCount.
			aCompMth methodProperties
				do: [ :aMthp | 
					(self violation: cri onMethod: aMthp)
						ifTrue: [ 
							aMthp rulesViolated add: cri class asString.
							result add: aMthp ] ] ].
	self alerts: result asOrderedCollection
]

{ #category : #accessing }
Alerts >> correctedWarns [
	^ correctedWarns
]

{ #category : #accessing }
Alerts >> correctedWarns: anObject [
	correctedWarns := anObject
]

{ #category : #accessing }
Alerts >> directory [
	^ directory
]

{ #category : #accessing }
Alerts >> directory: anObject [
	directory := anObject
]

{ #category : #csv }
Alerts >> generateCSV [
	"make a csv file from warnings list"

	| aFileName |
	aFileName := String new.
	aFileName := Smalltalk version asString , '-' , self package asString , '.csv'.
	self generateCSVinFileNamed: aFileName
]

{ #category : #csv }
Alerts >> generateCSVinFileNamed: aFileName [
	| stream version cote |
	cote := ''''.
	version := Smalltalk version.
	stream := FileStream forceNewFileNamed: aFileName.
	self alerts
		do: [ :warn | 
			stream nextPutAll: cote , warn version asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn rule asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn package asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn categorie asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn classe asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn selector asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn messagesCount asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn tempsVarCount asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn hasInstVarRef asString.
			stream nextPutAll: ''';'''.
			stream nextPutAll: warn containsHalt asString.
			stream nextPutAll: ''';'''.
			stream
				nextPutAll: warn stamp , cote;
				cr ].
	stream close
]

{ #category : #csv }
Alerts >> getAlertsFromFileNamed: aCSVFile [
	| aStream lines tokens |
	tokens := OrderedCollection new.
	aStream := FileStream readOnlyFileNamed: aCSVFile.
	aStream reset.
	lines := self getLinesFrom: aStream.
	lines
		do: [ :line | 
			| tok |
			tok := self getTokensFrom: line.
			tokens add: tok ].
	tokens
		do: [ :tok | 
			| aCWarn |
			aCWarn := ACorrectedWarning new.
			aCWarn initializeWith: tok.
			(aCWarn rule = '') 
				ifFalse: [ self addAlert: aCWarn ] ]
]

{ #category : #running }
Alerts >> getAllAddedWarnings [
	"This method take a directory in wich we have different commits of packages, sort by package name and by number, load a version of a package into the image, collect critics and store it then load the next version collect critics an compare with the previous the result consist of an ACompositeCWarning wich contains added critics"

	| result alerts1 oldVersion |
	result := ACompositeCWarning new.
	packages
		keysAndValuesDo: [ :k :v | 
			| j version |
			packageName := k asString.
			j := v asOrderedCollection
				sorted: [ :a :b | (a basenameWithoutExtension copyAfterLast: $.) asInteger <= (b basenameWithoutExtension copyAfterLast: $.) asInteger ].
			self clean.
			oldVersion := j first basenameWithoutExtension.
			self loadVersion: oldVersion.
			alerts1 := (self collectDataForPackage: packageName) alerts.
			(2 to: j size)
				do: [ :i | 
					| alerts2 newVersion |
					newVersion := (j at: i) basenameWithoutExtension.
					self clean.
					self loadVersion: newVersion.
					alerts2 := (self collectDataForPackage: packageName) alerts.
					alerts1
						do: [ :aMthp1 | 
							| temp |
							temp := OrderedCollection new.
							alerts2
								do: [ :aMthP2 | 
									|  y|
									version := self setVersions: oldVersion and: newVersion.
									"x := aMthp1 correctedWarningsIn: aMthP2."
									y:= aMthp1 addedWarningsIn: aMthP2 .
									y isNotEmpty 
										ifTrue: [ temp addAll: y ] ].
							temp isNotEmpty
								ifTrue: [ 
									temp do: [ :e | e setVersions: version ].
									result acwarns addAll: temp ] ].
					alerts1 := alerts2.
					oldVersion := newVersion ] ].
	^ result
]

{ #category : #running }
Alerts >> getAllAddedWarningsFrom: aPath [
	self setWithDirectory: aPath.
	self getAllAddedWarnings.
]

{ #category : #running }
Alerts >> getAllCorrectedWarnings [
	"This method take a directory in wich we have different commits of packages, sort by package name and by number, load a version of a package into the image, collect critics and store it then load the next version collect critics an compare with the previous the result consist of an ACompositeCWarning wich contains corrected critics"

	| alerts1 oldVersion start |
	correctedWarns := ASTON getACompositeCWarning.
	packageHistory := ASTON getAPackageHistory .
	start := correctedWarns start.
	packages
		keysAndValuesDo: [ :k :v | 
			| j version |
			packageName := k asString.
			ASTON packageName: packageName.
			j := v asOrderedCollection
				sorted: [ :a :b | (a basenameWithoutExtension copyAfterLast: $.) asInteger <= (b basenameWithoutExtension copyAfterLast: $.) asInteger ].
			self clean.
			oldVersion := (j at: start) basenameWithoutExtension.
			self loadVersion: oldVersion.
			alerts1 := (self collectDataForPackage: packageName) alerts.
			packageHistory setVersionHistory: oldVersion.
			packageHistory resetCurrentHistory  .
			(start + 1 to: j size)
				do: [ :i | 
					| alerts2 newVersion |
					newVersion := (j at: i) basenameWithoutExtension.
					self clean.
					self loadVersion: newVersion.
					alerts2 := (self collectDataForPackage: packageName) alerts.
					packageHistory setVersionHistory: newVersion.
					packageHistory resetCurrentHistory  .
					alerts1 
						do: [ :aMthp1 | 
							| temp |
							temp := OrderedCollection new.
							alerts2 
								do: [ :aMthP2 | 
									| x |
									version := self setVersions: oldVersion and: newVersion.
									((aMthp1 = aMthP2 ) ) ifTrue: 
									[x := aMthp1 correctedWarningsIn: aMthP2.
									x isNotEmpty
										ifTrue: [ temp addAll: x ] ]].
							temp isNotEmpty
								ifTrue: [ 
									temp do: [ :e | e setVersions: version ].
									correctedWarns acwarns addAll: temp ] ].
					alerts1 := alerts2.
					oldVersion := newVersion.
					correctedWarns start: i.
					correctedWarns generateFile.
					packageHistory generateFile ] ]
]

{ #category : #running }
Alerts >> getAllCorrectedWarningsFrom: aPath [
	self setWithDirectory: aPath.
	^self getAllCorrectedWarnings.
]

{ #category : #running }
Alerts >> getAllDeletedWarnings [
	"This method take a directory in wich we have different commits of packages, sort by package name and by number, load a version of a package into the image, collect critics and store it then load the next version collect critics an compare with the previous the result consist of an ACompositeCWarning wich contains corrected critics"

	| result alerts1 oldVersion |
	result := ACompositeCWarning new.
	packages
		keysAndValuesDo: [ :k :v | 
			| j version |
			packageName := k asString.
			j := v asOrderedCollection
				sorted: [ :a :b | (a basenameWithoutExtension copyAfterLast: $.) asInteger <= (b basenameWithoutExtension copyAfterLast: $.) asInteger ].
			self clean.
			oldVersion := j first basenameWithoutExtension.
			self loadVersion: oldVersion.
			alerts1 := self collectDataForPackage: packageName.
			(2 to: j size)
				do: [ :i | 
					| alerts2 newVersion |
					newVersion := (j at: i) basenameWithoutExtension.
					self clean.
					self loadVersion: newVersion.
					alerts2 := self collectDataForPackage: packageName.
					alerts1 alerts
						do: [ :aMthp1 | 
							| temp |
							temp := OrderedCollection new.
							(alerts2 includes: aMthp1)
								ifFalse: [ 
									| x |
									x := OrderedCollection new.
									version := self setVersions: oldVersion and: newVersion.
									aMthp1 rulesViolated do: [ :r | x add: (aMthp1  initializeCorrectedAlertsAgainst: aMthp1  with: r) ].
									x isNotEmpty
										ifTrue: [ temp addAll: x ] ].
							temp isNotEmpty
								ifTrue: [ 
									temp do: [ :e | e setVersions: version ].
									result acwarns addAll: temp ] ].
					alerts1 := alerts2.
					oldVersion := newVersion ] ].
	^ result
]

{ #category : #running }
Alerts >> getAllDeletedWarningsFrom: aPath [
	self setWithDirectory: aPath.
	^self getAllDeletedWarnings .
]

{ #category : #running }
Alerts >> getAllHistoryFrom: aPath [
	self setWithDirectory: aPath.
	self getHistory  .
]

{ #category : #running }
Alerts >> getHistory [
	"This method take a directory in wich we have different commits of packages, sort by package name and by number, load a version of a package into the image, collect critics and store it then load the next version collect critics an compare with the previous the result consist of an ACompositeCWarning wich contains corrected critics"

	|   oldVersion |

	packages
		keysAndValuesDo: [ :k :v | 
			| j  |
			packageName := k asString.
			j := v asOrderedCollection
				sorted: [ :a :b | (a basenameWithoutExtension copyAfterLast: $.) asInteger <= (b basenameWithoutExtension copyAfterLast: $.) asInteger ].

			(1 to: j size)
				do: [ :i | 
					|  newVersion env  |
					newVersion := (j at: i) basenameWithoutExtension.
					self clean.
					self loadVersion: newVersion.
					env := (RPackage  organizer packages select: [:e |  e packageName =  packageName  ]) first.
					Transcript show: (newVersion ,  ' number of classes : ', (env  classes size) asString ).
					Transcript cr.
					env classes do: 
					[:c | 
					Transcript show: (c name,  ' number of methods : ', (c  methods size) asString ).
					Transcript cr].
					
					oldVersion := newVersion ] ].
	
]

{ #category : #'as yet unclassified' }
Alerts >> includes: anAlert [
	
	^ self alerts includes: anAlert 
	
]

{ #category : #initialize }
Alerts >> initialize [
	super initialize.
	alerts := OrderedCollection new.
	directory := '/home/hayatou/Bureau/TestFolder' asFileReference .
	packageName := String new.
	packages := OrderedCollection new.
	packageHistory := APackageHistory new.
	correctedWarns := ACompositeCWarning new.
]

{ #category : #gofer }
Alerts >> loadVersion: aMCPackVersion [
	"Load a specific version aMCaMCPackVersion of a package into the image"
	Gofer new
		directory: directory;
		version: aMCPackVersion;
		disableRepositoryErrors;
		load
]

{ #category : #accessing }
Alerts >> packageHistory [
	^ packageHistory
]

{ #category : #accessing }
Alerts >> packageHistory: anObject [
	packageHistory := anObject
]

{ #category : #accessing }
Alerts >> packageName [
	^ packageName
]

{ #category : #accessing }
Alerts >> packageName: anObject [
	packageName := anObject
]

{ #category : #accessing }
Alerts >> packages [
	^ packages
]

{ #category : #accessing }
Alerts >> packages: anObject [
	packages := anObject
]

{ #category : #running }
Alerts >> removeAlert: anAlert [
	self alerts: (self alerts reject: [:e | e=anAlert ]).
]

{ #category : #running }
Alerts >> run [
	"This method take a directory in wich we have different commits of packages, sort by package name and by number, load a version of a package into the image, collect critics and store it then load the next version collect critics an compare with the previous the result consist of an ACoACompositeCWarning wich contains corrected critics"

	| result alerts1 oldVersion |
	result := ACompositeCWarning new.
	packages
		keysAndValuesDo: [ :k :v | 
			| j version |
			packageName := k asString.
			j := v asOrderedCollection
				sorted: [ :a :b | (a basenameWithoutExtension copyAfterLast: $.) asInteger <= (b basenameWithoutExtension copyAfterLast: $.) asInteger ].
			self clean.
			oldVersion := j first basenameWithoutExtension.
			self loadVersion: oldVersion.
			alerts1 := (self collectDataForPackage: packageName) alerts.
			(2 to: j size)
				do: [ :i | 
					| alerts2 newVersion |
					newVersion := (j at: i) basenameWithoutExtension.
					self clean.
					self loadVersion: newVersion.
					alerts2 := (self collectDataForPackage: packageName) alerts.
					alerts1
						do: [ :aMthp1 | 
							| temp |
							temp := OrderedCollection new.
							alerts2
								do: [ :aMthP2 | 
									|  y|
									version := self setVersions: oldVersion and: newVersion.
									"x := aMthp1 correctedWarningsIn: aMthP2."
									y:= aMthp1 addedWarningsIn: aMthP2 .
									y isNotEmpty 
										ifTrue: [ temp addAll: y ] ].
							temp isNotEmpty
								ifTrue: [ 
									temp do: [ :e | e setVersions: version ].
									result acwarns addAll: temp ] ].
					alerts1 := alerts2.
					oldVersion := newVersion ] ].
	^ result
]

{ #category : #running }
Alerts >> setVersions: oldVersion and: newVersion [
	|result|
	result := OrderedCollection new.
	^  result addAll: {oldVersion. newVersion }.
]

{ #category : #running }
Alerts >> setWithDirectory: aFileReference [
	"set the directory that contains commits  "

	directory := aFileReference asFileReference.
	packages := directory files groupedBy: [ :e | e basename copyUpToLast: $- ]
]

{ #category : #running }
Alerts >> violation: cri onMethod: aMthP [
	"this method verify if a method vialate a critic"

	^ cri result classes anySatisfy: [ :c | (cri result selectorsForClass: c) includes: aMthP selecteur ]
]
