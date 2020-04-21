Extension { #name : #RBCompositeLintRule }

{ #category : #'*Alerts' }
RBCompositeLintRule >> leaves [

	^ rules gather: [ :rule | rule leaves ]	

]

{ #category : #'*Alerts' }
RBCompositeLintRule >> removeRule: aRule [

	(rules anySatisfy: [ :rule | rule name = aRule name] )
		ifTrue: [rules := rules reject:  [ :rule | rule name = aRule name]]
		 ifFalse: [rules do: [ :rule |
				rule isComposite 
					ifTrue: [rule removeRule: aRule]]] 
]
