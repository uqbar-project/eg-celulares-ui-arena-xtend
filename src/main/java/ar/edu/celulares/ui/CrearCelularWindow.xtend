package ar.edu.celulares.ui

import ar.edu.celulares.domain.Celular
import org.uqbar.arena.windows.WindowOwner

class CrearCelularWindow extends EditarCelularWindow {
	
	new(WindowOwner owner, Celular model) {
		super(owner, model)
	}
	
	override defaultTitle() {
		"Alta de un nuevo cliente"
	}
}