"
An ACompositeCWarning  contains a collection of ACorectedWarnings.
==============================
you can do Analysis on it like grouping by rule type,  deleted or added items in ACorrectedWarning instance variables. 
==============================
"
Class {
	#name : #ACompositeCWarning,
	#superclass : #ASTON,
	#instVars : [
		'acwarns'
	],
	#category : #Alerts
}

{ #category : #accessing }
ACompositeCWarning >> acwarns [
	^ acwarns
]

{ #category : #accessing }
ACompositeCWarning >> acwarns: anObject [
	acwarns := anObject
]

{ #category : #accessing }
ACompositeCWarning >> addAWarn: aWarn [
	self acwarns add: aWarn
]

{ #category : #analysis }
ACompositeCWarning >> allCorrectedWarnInSmallCorrection [
"alerts corrected in a method that not containt other correction."
	|temp|
	temp:=OrderedCollection new.
	self acwarns do: [ :e |
		((self inSameMethodWith: e) size = 1) ifTrue: [ temp add: e ] ].
	^temp
]

{ #category : #'as yet unclassified' }
ACompositeCWarning >> allRules [
	^#('RBToDoRule' 'RBGuardClauseRule' 'RBUnreferencedVariablesRule' 'RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule' 'RBFileBlocksRule' 'RBAddRemoveDependentsRule' 'RBUnwindBlocksRule' 'RBYourselfNotUsedRule' 'RBToDoCollectRule' 'RBCollectSelectNotUsedRule' 'RBReturnsIfTrueRule' 'RBUnnecessaryAssignmentRule' 'RBCodeCruftLeftInMethodsRule' 'RBTranslateLiteralsInMenusRule' 'RBImplementedNotSentRule' 'RBInstVarInSubclassesRule' 'RBRefersToClassRule' 'RBRepeteadMethodsInTheSuperclassRule' 'RBMethodHasNoTimeStampRule' 'RBModifiesCollectionRule' 'RBInconsistentMethodClassificationRule' 'RBInstanceVariableCapitalizationRule' 'RBWhileTrueRule' 'RBUsesAddRule' 'RBExcessiveInheritanceRule' 'RBCollectionCopyEmptyRule' 'RBSendsMethodDictRule' 'RBEmptyExceptionHandlerRule' 'RBMissingSuperSendsRule' 'RBSearchingLiteralRule' 'RBSubclassResponsibilityNotDefinedRule' 'RBTempsReadBeforeWrittenRule' 'RBPlatformDependentUserInteractionRule' 'RBExcessiveArgumentsRule' 'RBBetweenAndRule' 'RBUncommonMessageSendRule' 'RBBooleanPrecedenceRule' 'RBEndTrueFalseRule' 'RBFloatEqualityComparisonRule' 'RBPrecedenceRule' 'RBEqualNotUsedRule' 'RBToDoWithIncrementRule' 'FAMIXMetaModelClassesNotDeclaredInFameRule' 'FAMIXMetaModelClassesShouldNotOverrideRule' 'FameOppositeAttributeShouldPointBackRule' 'RBExplicitRequirementMethodsRule' 'RBCollectionProtocolRule' 'RBDetectIfNoneRule' 'RBMinMaxRule' 'RBExtraBlockRule' 'RBAllAnyNoneSatisfyRule' 'FameNameConventionBetweenFM3AndSmalltalkRule' 'RBEquivalentSuperclassMethodsRule' 'RBAtIfAbsentRule' 'RBSuperSendsRule' 'RBBadMessageRule' 'RBVariableReferencedOnceRule' 'RBDefinesEqualNotHashRule' 'RBUnclassifiedMethodsRule' 'RBLongMethodsRule' 'RBNotEliminationRule' 'RBUnconditionalRecursionRule' 'RBAbstractClassRule' 'RBMethodSourceContainsLinefeedsRule' 'RBCollectionMessagesToExternalObjectRule' 'RBSendsDifferentSuperRule' 'RBDetectContainsRule' 'RBExcessiveVariablesRule' 'RBAsOrderedCollectionNotNeededRule' 'RBSendsDeprecatedMethodToGlobalRule' 'RBAssignmentInIfTrueRule' 'RBOnlyReadOrWrittenVariableRule' 'RBMissingYourselfRule' 'RBLiteralArrayCharactersRule' 'RBThreeElementPointRule' 'RBCascadedNextPutAllsRule' 'RBUnderscoreAssignmentRule' 'RBJustSendsSuperRule' 'RBUnoptimizedToDoRule' 'RBAssignmentInBlockRule' 'RBEqualNilRule' 'RBTemporaryVariableCapitalizationRule' 'RBSuperSendsNewRule' 'RBThemeAPIUpdateRule' 'RBLiteralArrayContainsCommaRule' 'RBClassInstVarNotInitializedRule' 'RBOverridesSpecialMessageRule' 'RBConsistencyCheckRule' 'RBExcessiveMethodsRule' 'RBVariableAssignedLiteralRule' 'RBOnlyReadOrWrittenTemporaryRule' 'RBMissingSubclassResponsibilityRule' 'RBkeysDoRule' 'FameSuperclassMetaDescribedExistRule' 'RBIfTrueReturnsRule' 'RBContainsRule' 'RBIfTrueBlocksRule' 'RBUnoptimizedAndOrRule' 'RBUsesTrueRule' 'RBRemoveAssignmentWithoutEffectRule' 'CodeRewritingRule' 'RBEqualsTrueRule' 'RBShouldntRaiseErrorRule' 'RBReturnInEnsureRule' 'FameOppositeClassNotExistRule' 'RBStringConcatenationRule' 'RBReturnsBooleanAndOtherRule' 'RBLocalMethodsOfAClassNotInItsTraitComposition' 'RBTempVarOverridesInstVarRule' 'RBSizeCheckRule' 'RBTrueFalseDuplicationRule')
]

{ #category : #analysis }
ACompositeCWarning >> allWithAddedLiterals [
	 ^self  acwarns  select: [:e | e   hasAdded:  e literals  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithAddedMessages [
	 ^self  acwarns  select: [:e | e   hasAdded:  e messages  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithAddedPragmas [
	 ^self  acwarns  select: [:e | e   hasAdded:  e pragmas  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithAddedVariables [
	 ^self  acwarns  select: [:e | e   hasAdded:  e variables  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithChangedCategorie [
	 ^self  acwarns  select: [:e | e  categorie size = 2  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithChangedProtocol [
	 ^self  acwarns  select: [:e | e isChanged: e protocol  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithChangedRetour [
	 ^self  acwarns  select: [:e | e  retour size = 2  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithDeletedLiterals [
	 ^self  acwarns  select: [:e | e   hasDeleted: e literals  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithDeletedMessages [
	 ^self  acwarns  select: [:e | e   hasDeleted: e messages  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithDeletedPragmas [
	 ^self  acwarns  select: [:e | e   hasDeleted: e pragmas  ].

]

{ #category : #analysis }
ACompositeCWarning >> allWithDeletedVariables [
	 ^self  acwarns  select: [:e | e   hasDeleted: e variables  ].

]

{ #category : #statistique }
ACompositeCWarning >> correctedWarnings [
"return an ordered collection of warning that was corrected at least one time"
	|result|
	result:=OrderedCollection new.
	self correctedWarningsOccurence keysAndValuesDo: [ :k :v | (v > 0) ifTrue: [ result add: k ] ].
	^ result
]

{ #category : #statistique }
ACompositeCWarning >> correctedWarningsOccurence [
"return a dictionary wich key is lint rule and value is number of corrected warning of type rule"
	| result |
	result := Dictionary new.
	self allRules
		do: [ :rule | 
			result at: rule put: (self numberOfCorrected: rule) ].
				^result.
]

{ #category : #'as yet unclassified' }
ACompositeCWarning >> generateFile [
	super generateFileWithSuffix: '-ACCWarning'
]

{ #category : #analysis }
ACompositeCWarning >> groupCWarnByRule [
	 ^self  acwarns  groupedBy: [:e | e rule ].

]

{ #category : #analysis }
ACompositeCWarning >> inSameMethodWith: aCorrectedWarn [
	| res |
	res := OrderedCollection new.
	(self acwarns includes: aCorrectedWarn)
		ifFalse: [ ^ res ].
	self acwarns
		do: [ :e | 
			((e version = aCorrectedWarn version)
				and: [ 
					e package = aCorrectedWarn package
						and: [ e classe = aCorrectedWarn classe and: [ e selector = aCorrectedWarn selector and: [ e stamp = aCorrectedWarn stamp ] ] ] ]) 
					ifTrue: [res add: e]].
				^res
]

{ #category : #initialization }
ACompositeCWarning >> initialize [ 
	super initialize .
	acwarns := OrderedCollection new.
	
]

{ #category : #statistique }
ACompositeCWarning >> numberOfCorrected: aLintRule [
	"return the number of time aLinaLintRule was corrested throught all versions of the packages"

	| count |
	count := 0.
	(self allRules includes: aLintRule)
		ifFalse: [ ^ -1 ].
	acwarns
		do: [ :each | 
			each rule = aLintRule
				ifTrue: [ count := count + 1 ] ].
	^ count
]

{ #category : #statistique }
ACompositeCWarning >> numberOfCorrectedWarnings [
"return the total number of corrected warning over all version of the package"
	| total |
	total := 0.
	self correctedWarningsOccurence 
		keysAndValuesDo:  [ :k :v | 
			total:=total+v ].
				^total.
]

{ #category : #accessing }
ACompositeCWarning >> removeAWarn: aWarn [
	self acwarns remove: aWarn
]

{ #category : #running }
ACompositeCWarning >> setVersions: aVersions [
	self acwarns do: [ :e | e setVersions: aVersions ]
]
