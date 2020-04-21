Class {
	#name : #TestACorrectedWarning,
	#superclass : #TestCase,
	#instVars : [
		'cw'
	],
	#category : #'Alerts-Tests'
}

{ #category : #'as yet unclassified' }
TestACorrectedWarning >> setUp [
	cw:=ACorrectedWarning new.
]

{ #category : #'as yet unclassified' }
TestACorrectedWarning >> testDiffBetweenAnd [

	| res |
	res := cw diffBetween: (OrderedCollection withAll: #( a a b c a d)) and: (OrderedCollection withAll: #( a b c e e e )).
	self assert:res size equals:2.
	self assert:res first equals: (OrderedCollection withAll: #( a a d)).
	self assert:res second equals: (OrderedCollection withAll: #( e e e )).
]

{ #category : #'as yet unclassified' }
TestACorrectedWarning >> testInitializeAlertsBetweenAndWith [
	| a |
	a := AMethodProperties new methodPropertiesFor: Collection >> #copyWith:.
	a rulesViolated add: 'TestRule'.
	cw
		initializeAlertsBetween: a
		and: (AMethodProperties new methodPropertiesFor: Collection >> #copyWith:)
		with: 'TestRule'.
	self assert: cw rule = 'TestRule'	"cw contains a violation of TestRule"	"cw
		initializeAlertsBetween:
			a
				and: (AMethodProperties new methodPropertiesFor: Collection >> #copyWith:)
				with: 'TestNotInRule'.
	self assert: cw rule = ''."	"cw do not contains a violation of TestNotInRule"
]
