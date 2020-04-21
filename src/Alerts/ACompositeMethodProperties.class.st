"
An ACompositeMethodProperties contains a collection of AMethodProperties.
it main purpose is to collect all AMethodProperies for a given package.
========================================
usage
evaluate
---------------------------------
|a| 
a:= ACompositeMethodProperties new.
a forPackage: 'aPackageName'
----------------------------------------
======================================
"
Class {
	#name : #ACompositeMethodProperties,
	#superclass : #Object,
	#instVars : [
		'methodProperties'
	],
	#category : #Alerts
}

{ #category : #running }
ACompositeMethodProperties >> addAMethodProperties: amthP [
	methodProperties add: amthP
]

{ #category : #running }
ACompositeMethodProperties >> forPackage: aPackName [
	| pack aMthP |
	pack := RPackage   organizer packages select: [:e |  e packageName =  aPackName  ]. 
	pack
		do: [ :paI | 
			paI  packages asOrderedCollection first classes
				do: [ :class | 
					class isTrait
						ifFalse: [ 
							class methodDict asOrderedCollection
								do: [ :aCompMth | 
									aMthP := AMethodProperties new.
									aMthP methodPropertiesFor: aCompMth.
									self addAMethodProperties: aMthP ] ] ] ]. 
]

{ #category : #initialize }
ACompositeMethodProperties >> initialize [
	super initialize.
	methodProperties := OrderedCollection new
]

{ #category : #accessing }
ACompositeMethodProperties >> methodProperties [
	^ methodProperties
]

{ #category : #accessing }
ACompositeMethodProperties >> methodProperties: anObject [
	methodProperties := anObject
]

{ #category : #running }
ACompositeMethodProperties >> removeAMethodProperties: amthP [
	"remove amthP  from ACompositeMethodProperties "

	(self methodProperties includes: amthP)
		ifTrue: [ 
			self methodProperties
				reject: [ :e | 
					e package = amthP package and: [ e classe = amthP classe  and: [ e selecteur = amthP selecteur ] ] ] ] .
			^ self
]
