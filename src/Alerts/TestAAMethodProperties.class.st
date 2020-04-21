Class {
	#name : #TestAAMethodProperties,
	#superclass : #TestCase,
	#instVars : [
		'mp'
	],
	#category : #'Alerts-Tests'
}

{ #category : #running }
TestAAMethodProperties >> setUp [
	mp := AMethodProperties new.

]

{ #category : #tests }
TestAAMethodProperties >> testProperties [
	mp methodPropertiesFor: ResourceForAMethodProperties>>#getAlertsFromFileNamed: .

	self assert: mp selecteur equals: #getAlertsFromFileNamed:.
	self assert: mp categorie equals: 'Alerts-Tests'.
	self assert: mp package equals: 'Alerts-Tests'.
	self assert: mp classe equals: 'ResourceForAMethodProperties'.
	self assert: mp variables size equals: 31.
	self assert: mp literals size equals: 1.
	self assert: mp pragmas size equals: 0.
	self assert: mp messages size equals: 14.
	self assert: mp rulesViolated size equals: 0.

]

{ #category : #tests }
TestAAMethodProperties >> testPropertyRulesViolated [
	| checker rules |
	
	"Run SmallLint on the class"
	checker  := RBSmalllintChecker new.
	rules := RBCompositeLintRule allGoodRules.
	rules resetResult.
	checker rule: rules.
	checker environment: (RBPackageEnvironment new packages: (RPackage organizer packages select: [:e |  e packageName =  'Alerts-Tests' ] ) ). 
	checker checkClass: ResourceForAMethodProperties.  "needed to set the class in the checker's context"
	checker checkMethodsForClass: ResourceForAMethodProperties.

	"Gets the violation from SmallLint for the method"
	mp methodPropertiesFor: ResourceForAMethodProperties>>#simpleMethodCallOnVar .
	rules leaves do: [:rule |
		(Alerts new violation: rule  onMethod: mp)
				ifTrue: [ mp rulesViolated add: (rule name) ]
	].

	self assert: mp rulesViolated size equals: 3

]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataAssignementLiteral [

	mp receiveData: (ResourceForAMethodProperties>>#assignementLiteral) parseTree body.
	
	self assert: mp variables size equals: 2
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataAssignementSimpleMethodCallOnSelf [

	mp receiveData: (ResourceForAMethodProperties>>#assignementSimpleMethodCallOnSelf) parseTree body.
	
	self assert: mp variables size equals: 3
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataAssignementSimpleMethodCallOnVar [

	mp receiveData: (ResourceForAMethodProperties>>#assignementSimpleMethodCallOnVar) parseTree body.
	
	self assert: mp variables size equals: 3
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataSimpleMethodCallOnLiteral [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodCallOnLiteral) parseTree body.
	
	self assert: mp variables size equals: 0
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataSimpleMethodCallOnSelf [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodCallOnSelf) parseTree body .
	
	self assert: mp variables size equals: 1 
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataSimpleMethodCallOnVar [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodCallOnVar) parseTree body .
	
	self assert: mp variables size equals: 2 
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataSimpleMethodWithArgument [

	 (ResourceForAMethodProperties>>#simpleMethodWithArgument:) parseTree arguments do:[:e | mp receiveData: e].
	
	self assert: mp variables size equals: 1
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataSimpleMethodWithArguments [

	 (ResourceForAMethodProperties>>#simpleMethodWithArguments:and:) parseTree arguments do:[:e | mp receiveData: e].
	
	self assert: mp variables size equals: 2
]

{ #category : #tests }
TestAAMethodProperties >> testReceiveDataSimpleMethodWithLocal [

	mp receiveData: (ResourceForAMethodProperties>>#simpleMethodWithLocal) parseTree body.
	
	self assert: mp variables size equals: 1
]
