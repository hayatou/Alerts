Class {
	#name : #TestACompositeCWarning,
	#superclass : #TestCase,
	#instVars : [
		'acw'
	],
	#category : #'Alerts-Tests'
}

{ #category : #'as yet unclassified' }
TestACompositeCWarning >> setUp [
	acw:=ACompositeCWarning new.
]

{ #category : #'as yet unclassified' }
TestACompositeCWarning >> testAddWarn [
	|a|
	a:=ACorrectedWarning new.
	self assert: (acw acwarns size) = 0.
	acw addAWarn: a.
	self assert: (acw acwarns size) =1.
]

{ #category : #'as yet unclassified' }
TestACompositeCWarning >> testRemoveWarn [
	| a |
	a := ACorrectedWarning new.
	acw addAWarn: a.
	self assert: acw acwarns size = 1.
	acw removeAWarn: a.
	self assert: acw acwarns size = 0
]

{ #category : #'as yet unclassified' }
TestACompositeCWarning >> testSetVersions [
	| versions a |
	versions := #('A' 'B').
	a := ACorrectedWarning new.
	acw addAWarn: a.
	self assert: acw acwarns first version size = 0.
	acw setVersions: versions.
	self assert: acw acwarns first version size = 2
]
