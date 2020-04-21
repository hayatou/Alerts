Class {
	#name : #TestASmallLint,
	#superclass : #TestCase,
	#instVars : [
		'asm'
	],
	#category : #'Alerts-Tests'
}

{ #category : #'as yet unclassified' }
TestASmallLint >> setUp [
	asm:=ASmallLint new.
]

{ #category : #'as yet unclassified' }
TestASmallLint >> testWarningsFor [
	| a |
	asm warningsFor: 'Alerts'.
	a := 0.
	asm result do: [ :r | a := a + r problemCount ].
	self assert: a > 2
]
