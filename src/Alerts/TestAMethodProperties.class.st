Class {
	#name : #TestAMethodProperties,
	#superclass : #TestCase,
	#instVars : [
		'mp'
	],
	#category : #'Alerts-Tests'
}

{ #category : #running }
TestAMethodProperties >> setUp [
	mp := AMethodProperties new.

]

{ #category : #tests }
TestAMethodProperties >> testDiffReturn [
	"different package"

	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #copyWith:)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: LinkedList >> #copyWith:)) size =0.	"different class"
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #size)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: HashedCollection >> #size)) size =0.	"different method"
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #remove:)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: Collection >> #add:)) size =0.	"same all"
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #remove:)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: Collection >> #remove:)) size =0.
	"self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #remove:)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: Collection >> #remove:)) variables size
		equals: 2.
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #remove:)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: Collection >> #remove:)) variables first isEmpty.
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #remove:)
				correctedWarningsIn: (AMethodProperties new methodPropertiesFor: Collection >> #remove:)) variables second isEmpty"
]

{ #category : #tests }
TestAMethodProperties >> testEqual [
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #copyWith:)
				= (AMethodProperties new methodPropertiesFor: Collection >> #copyWith:)).	"different class"
	self
		assert:
			((AMethodProperties new methodPropertiesFor: Collection >> #size)
				= (AMethodProperties new methodPropertiesFor: HashedCollection >> #size)) not.	"different method"
	
	
]

{ #category : #tests }
TestAMethodProperties >> testInitialize [
	self assert: mp compiledMethod = CompiledMethod new.
	self assert: mp pragmas = OrderedCollection new.
	self assert: mp rulesViolated = OrderedCollection new.
	self assert: mp messages = OrderedCollection new.
	self assert: mp variables = OrderedCollection new.
	self assert: mp literals = OrderedCollection new.
	self assert: mp retour = OrderedCollection new
]

{ #category : #tests }
TestAMethodProperties >> testProperties [
	mp methodPropertiesFor: ResourceForAMethodProperties>>#getAlertsFromFileNamed: .

	self assert: mp selecteur equals: #getAlertsFromFileNamed:.
	self assert: mp categorie equals: 'Alerts-Tests'.
	self assert: mp package equals: 'Alerts'.
	self assert: mp classe equals: #ResourceForAMethodProperties.
	self assert: mp variables size equals: 31.
	self assert: mp retour size equals: 0.
	self assert: mp literals size equals: 1.
	self assert: mp pragmas size equals: 0.
	self assert: mp messages size equals: 14.
	self assert: mp rulesViolated size equals: 0.

]

{ #category : #tests }
TestAMethodProperties >> testPropertyRulesViolated [
	| checker rules |
	
	"Run SmallLint on the class"
	checker  := RBSmalllintChecker new.
	rules := RBCompositeLintRule allGoodRules.
	rules resetResult.
	checker rule: rules.
	checker environment: (RBPackageEnvironment new packages: (RPackage organizer packages select: [:e |  e packageName =  'Alerts' ] ) ). 
	checker checkClass: ResourceForAMethodProperties.  "needed to set the class in the checker's context"
	checker checkMethodsForClass: ResourceForAMethodProperties.

	"Gets the violation from SmallLint for the method"
	mp methodPropertiesFor: ResourceForAMethodProperties>>#simpleMethodCallOnVar .
	rules leaves do: [:cri |
		(Alerts new violation: cri  onMethod: mp)
				ifTrue: [ mp rulesViolated add: (cri class) ]
	].

	self assert: mp rulesViolated size equals: 4

]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataAssignementLiteral [

	mp receiveData: (ResourceForAMethodProperties>>#assignementLiteral) parseTree body.
	
	self assert: mp variables size equals: 2
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataAssignementSimpleMethodCallOnSelf [

	mp receiveData: (ResourceForAMethodProperties>>#assignementSimpleMethodCallOnSelf) parseTree body.
	
	self assert: mp variables size equals: 3
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataAssignementSimpleMethodCallOnVar [

	mp receiveData: (ResourceForAMethodProperties>>#assignementSimpleMethodCallOnVar) parseTree body.
	
	self assert: mp variables size equals: 3
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataSimpleMethodCallOnLiteral [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodCallOnLiteral) parseTree body.
	
	self assert: mp variables size equals: 0
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataSimpleMethodCallOnSelf [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodCallOnSelf) parseTree body .
	
	self assert: mp variables size equals: 1 
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataSimpleMethodCallOnVar [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodCallOnVar) parseTree body .
	
	self assert: mp variables size equals: 2 
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataSimpleMethodWithArgument [

	 (ResourceForAMethodProperties>>#simpleMethodWithArgument:) parseTree arguments do:[:e | mp receiveData: e].
	
	self assert: mp variables size equals: 1
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataSimpleMethodWithArguments [

	 (ResourceForAMethodProperties>>#simpleMethodWithArguments:and:) parseTree arguments do:[:e | mp receiveData: e].
	
	self assert: mp variables size equals: 2
]

{ #category : #tests }
TestAMethodProperties >> testReceiveDataSimpleMethodWithLocal [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodWithLocal) parseTree body.
	
	self assert: mp variables size equals: 1
]
