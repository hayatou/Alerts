Class {
	#name : #APackageHistory,
	#superclass : #ASTON,
	#instVars : [
		'packageHistories',
		'currentPackageHistory',
		'violationsHistories',
		'currentViolationsHistory'
	],
	#category : #Alerts
}

{ #category : #accessing }
APackageHistory >> allRules [
	^#('RBToDoRule' 'RBGuardClauseRule' 'RBUnreferencedVariablesRule' 'RBLiteralArrayContainsSuspiciousTrueFalseOrNilRule' 'RBFileBlocksRule' 'RBAddRemoveDependentsRule' 'RBUnwindBlocksRule' 'RBYourselfNotUsedRule' 'RBToDoCollectRule' 'RBCollectSelectNotUsedRule' 'RBReturnsIfTrueRule' 'RBUnnecessaryAssignmentRule' 'RBCodeCruftLeftInMethodsRule' 'RBTranslateLiteralsInMenusRule' 'RBImplementedNotSentRule' 'RBInstVarInSubclassesRule' 'RBRefersToClassRule' 'RBRepeteadMethodsInTheSuperclassRule' 'RBMethodHasNoTimeStampRule' 'RBModifiesCollectionRule' 'RBInconsistentMethodClassificationRule' 'RBInstanceVariableCapitalizationRule' 'RBWhileTrueRule' 'RBUsesAddRule' 'RBExcessiveInheritanceRule' 'RBCollectionCopyEmptyRule' 'RBSendsMethodDictRule' 'RBEmptyExceptionHandlerRule' 'RBMissingSuperSendsRule' 'RBSearchingLiteralRule' 'RBSubclassResponsibilityNotDefinedRule' 'RBTempsReadBeforeWrittenRule' 'RBPlatformDependentUserInteractionRule' 'RBExcessiveArgumentsRule' 'RBBetweenAndRule' 'RBUncommonMessageSendRule' 'RBBooleanPrecedenceRule' 'RBEndTrueFalseRule' 'RBFloatEqualityComparisonRule' 'RBPrecedenceRule' 'RBEqualNotUsedRule' 'RBToDoWithIncrementRule' 'FAMIXMetaModelClassesNotDeclaredInFameRule' 'FAMIXMetaModelClassesShouldNotOverrideRule' 'FameOppositeAttributeShouldPointBackRule' 'RBExplicitRequirementMethodsRule' 'RBCollectionProtocolRule' 'RBDetectIfNoneRule' 'RBMinMaxRule' 'RBExtraBlockRule' 'RBAllAnyNoneSatisfyRule' 'FameNameConventionBetweenFM3AndSmalltalkRule' 'RBEquivalentSuperclassMethodsRule' 'RBAtIfAbsentRule' 'RBSuperSendsRule' 'RBBadMessageRule' 'RBVariableReferencedOnceRule' 'RBDefinesEqualNotHashRule' 'RBUnclassifiedMethodsRule' 'RBLongMethodsRule' 'RBNotEliminationRule' 'RBUnconditionalRecursionRule' 'RBAbstractClassRule' 'RBMethodSourceContainsLinefeedsRule' 'RBCollectionMessagesToExternalObjectRule' 'RBSendsDifferentSuperRule' 'RBDetectContainsRule' 'RBExcessiveVariablesRule' 'RBAsOrderedCollectionNotNeededRule' 'RBSendsDeprecatedMethodToGlobalRule' 'RBAssignmentInIfTrueRule' 'RBOnlyReadOrWrittenVariableRule' 'RBMissingYourselfRule' 'RBLiteralArrayCharactersRule' 'RBThreeElementPointRule' 'RBCascadedNextPutAllsRule' 'RBUnderscoreAssignmentRule' 'RBJustSendsSuperRule' 'RBUnoptimizedToDoRule' 'RBAssignmentInBlockRule' 'RBEqualNilRule' 'RBTemporaryVariableCapitalizationRule' 'RBSuperSendsNewRule' 'RBThemeAPIUpdateRule' 'RBLiteralArrayContainsCommaRule' 'RBClassInstVarNotInitializedRule' 'RBOverridesSpecialMessageRule' 'RBConsistencyCheckRule' 'RBExcessiveMethodsRule' 'RBVariableAssignedLiteralRule' 'RBOnlyReadOrWrittenTemporaryRule' 'RBMissingSubclassResponsibilityRule' 'RBkeysDoRule' 'FameSuperclassMetaDescribedExistRule' 'RBIfTrueReturnsRule' 'RBContainsRule' 'RBIfTrueBlocksRule' 'RBUnoptimizedAndOrRule' 'RBUsesTrueRule' 'RBRemoveAssignmentWithoutEffectRule' 'CodeRewritingRule' 'RBEqualsTrueRule' 'RBShouldntRaiseErrorRule' 'RBReturnInEnsureRule' 'FameOppositeClassNotExistRule' 'RBStringConcatenationRule' 'RBReturnsBooleanAndOtherRule' 'RBLocalMethodsOfAClassNotInItsTraitComposition' 'RBTempVarOverridesInstVarRule' 'RBSizeCheckRule' 'RBTrueFalseDuplicationRule')
]

{ #category : #'as yet unclassified' }
APackageHistory >> allRulesIncludes: aRBLintRule [
	|allRules|
	allRules := self allRules .
	^ allRules includes: aRBLintRule .

]

{ #category : #'as yet unclassified' }
APackageHistory >> allVersions [
	|allPackages|
	allPackages := OrderedCollection new.
	allPackages addAll: (packageHistories keys asOrderedCollection ).
	^ allPackages.
]

{ #category : #accessing }
APackageHistory >> currentPackageHistory [
	^ currentPackageHistory
]

{ #category : #accessing }
APackageHistory >> currentPackageHistory: anObject [
	currentPackageHistory := anObject
]

{ #category : #accessing }
APackageHistory >> currentViolationsHistory [
	^ currentViolationsHistory
]

{ #category : #accessing }
APackageHistory >> currentViolationsHistory: anObject [
	currentViolationsHistory := anObject
]

{ #category : #ston }
APackageHistory >> generateFile [
	super generateFileWithSuffix: '-APackHistory'
]

{ #category : #'as yet unclassified' }
APackageHistory >> initialize [
	super initialize.
	currentPackageHistory  := Dictionary new.
	currentViolationsHistory  := Dictionary new.
	packageHistories := Dictionary new.
	violationsHistories := Dictionary new.
	
]

{ #category : #analyse }
APackageHistory >> numberOfClass [
"return the total number of rules violation in a version"
	|num|
	num:=0.
	self allVersions do: [:version | num:=num+ (self numberOfClassIn: version)].
	^num.
]

{ #category : #analyse }
APackageHistory >> numberOfClassIn: aVersion [
"return the total number of rules violation in a version"
	(self allVersions includes: aVersion ) ifFalse: [ ^(-1) ].
	^(packageHistories  at: aVersion) size.
]

{ #category : #analyse }
APackageHistory >> numberOfMethods [
"return the total number of rules violation in a version"
	|num |
	num:=0.
	self allVersions do: [ :version | num:=num+ (self numberOfMethodsIn: version) ].
	^num.
]

{ #category : #analyse }
APackageHistory >> numberOfMethodsIn: aVersion [
"return the total number of rules violation in a version"
	|num |
	num:=0.
	(self allVersions includes: aVersion ) ifFalse: [ ^(-1) ].
	(packageHistories  at: aVersion) valuesDo: [ :v | num:= num+v ].
	^num.
]

{ #category : #analyse }
APackageHistory >> numberOfStudiedRules [
	"return the total number of lint rule we studied"
	^ self allRules size
]

{ #category : #analyse }
APackageHistory >> numberOfStudiedVersions [
	"return the total number of lint rule we studied"
	^ packageHistories  size
]

{ #category : #analyse }
APackageHistory >> numberOfViolationsIn: aVersion [
"return the total number of rules violation in a version"
	|num |
	num:=0.
	(self allVersions includes: aVersion ) ifFalse: [ ^(-1) ].
	(violationsHistories  at: aVersion) valuesDo: [ :v | num:= num+v ].
	^num.
]

{ #category : #analyse }
APackageHistory >> numberOfViolationsOf: aRule [ 
"return the total number of violation of a lint rule named aRule in the history of the package"
	|num |
	num:=0.
	(self allRulesIncludes: aRule) ifFalse: [ ^(-1) ].
	violationsHistories valuesDo: [ :dict | 
		dict keysAndValuesDo:  [ :rule :value |
			(rule =aRule) ifTrue: [ num:=num+ value ] ]  ].
	^num
]

{ #category : #analyse }
APackageHistory >> numberOfViolationsPerRule [
"return a dictionary wich keys is rules and values the total number of violation the rule in the history of the package"
	|result rules |
	result := Dictionary new.
	rules := self allRules.
	rules do: [:each | result at: each put: (self numberOfViolationsOf: each) ].
	^result
	
]

{ #category : #accessing }
APackageHistory >> packageHistories [
	^ packageHistories
]

{ #category : #accessing }
APackageHistory >> packageHistories: anObject [
	packageHistories := anObject
]

{ #category : #accessing }
APackageHistory >> resetCurrentHistory [
	self setCurrentPackageHistory .
	self setCurrentViolationsHistory 
]

{ #category : #analyse }
APackageHistory >> rulesNeverViolated [
"return a colletion of rule wich in never violated in the history of the package"
	|result  |
	result := OrderedCollection  new .
	self numberOfViolationsPerRule keysAndValuesDo: [:k :v | (v= 0) ifTrue: [result add: k]].
	^result
	
]

{ #category : #accessing }
APackageHistory >> setCurrentPackageHistory [
	 currentPackageHistory := Dictionary new.
]

{ #category : #accessing }
APackageHistory >> setCurrentViolationsHistory [
	 currentViolationsHistory:=Dictionary new.
]

{ #category : #'as yet unclassified' }
APackageHistory >> setPackageHistory: aPackage [ 
	|pack|
	pack:=(RPackage organizer packages select: [:e | e packageName =  aPackage ]) first.
	pack classes do: [:c |  currentPackageHistory at:(c name asString ) put: (c methods size)] .
]

{ #category : #'as yet unclassified' }
APackageHistory >> setVersionHistory: aVersionOfPackage [
	violationsHistories at: aVersionOfPackage put: currentViolationsHistory.
	packageHistories at: aVersionOfPackage put: currentPackageHistory
]

{ #category : #accessing }
APackageHistory >> violationsHistories [
	^ violationsHistories
]

{ #category : #accessing }
APackageHistory >> violationsHistories: anObject [
	violationsHistories := anObject
]
