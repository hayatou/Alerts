"
An AWarnings is designed to run SmallLint rules on a Package an return all violations.

Instance Variables
	checker:		is in charge of checking method and classes of an environment (a Package in our case) 
	environment:		containt all classes and methods of a package we want to check
	result:		is a kind of browserEnvironment wich containt all rules violations
	rules:		SmallLint rule
====================================
To use it you can just execute this
-------------------------------
|a|  
a:= ASmallLint new.
a warningsFor: 'ST80'.
a result 
------------------------------
====================================
"
Class {
	#name : #ASmallLint,
	#superclass : #Object,
	#instVars : [
		'environment',
		'rules',
		'checker'
	],
	#category : #Alerts
}

{ #category : #'as yet unclassified' }
ASmallLint >> asSelectorEnvironment:rbResult [
	^ (rbResult isKindOf: RBMultiEnvironment)
		ifTrue: [ rbResult asSelectorEnvironment ]
		ifFalse: [ rbResult ]
]

{ #category : #accessing }
ASmallLint >> checker [
	^ checker
]

{ #category : #accessing }
ASmallLint >> checker: anObject [
	checker := anObject
]

{ #category : #accessing }
ASmallLint >> environment [
	^ environment
]

{ #category : #accessing }
ASmallLint >> environment: anObject [
	environment := anObject
]

{ #category : #initialize }
ASmallLint >> initialize [
	super initialize.
	environment := RPackage .
	rules := RBCompositeLintRule.
	checker := RBSmalllintChecker new
]

{ #category : #accessing }
ASmallLint >> result [

	^ rules leaves collect: [ :l | l result ]
]

{ #category : #accessing }
ASmallLint >> rules [
	^ rules
]

{ #category : #accessing }
ASmallLint >> rules:aCollection [
	rules := aCollection
]

{ #category : #running }
ASmallLint >> warningsFor: aPackageName [
	|env  check |
	env := environment  organizer packages select: [:e |  e packageName =  aPackageName  ].
	check := self checker.
	self rules: rules allGoodRules.
	self rules resetResult. 
	env do: [:paI |  
		check rule: rules.	
		check environment:  (RBPackageEnvironment new packages: {paI}) . 
		paI classes do: [ :class |	
			 (class isTrait ) ifFalse: [ 
				 check  checkClass: class.
				 check  checkMethodsForClass: class] ] ]. 
]
