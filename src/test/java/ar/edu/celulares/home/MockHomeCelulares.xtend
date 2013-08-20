package ar.edu.celulares.home

import ar.edu.celulares.domain.Celular

class MockHomeCelulares extends HomeCelulares {

	override def init() {
		var celular = new Celular
		celular.nombre = "Ricardo Ruben"
		celular.numero = 44667816
		celular.modeloCelular = getModelo("NOKIA LUMIA 625")
		celular.recibeResumenCuenta = false
		this.create(celular)
	}
	
}
