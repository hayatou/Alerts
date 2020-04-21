Extension { #name : #CompiledMethod }

{ #category : #'*Alerts' }
CompiledMethod >> containsHalt [

	
	#( #halt #halt: #haltOnce #haltOnce: #haltIf: )
		do: [:aLit | (self hasLiteral: aLit)
				ifTrue: [^ true]].
	^ false
]
