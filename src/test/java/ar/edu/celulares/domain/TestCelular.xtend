package ar.edu.celulares.domain

import java.math.BigDecimal
import static org.junit.Assert.*;
import org.junit.Before
import org.junit.Test
import org.uqbar.commons.model.UserException

class TestCelular {
	
	Celular celularNoResumen
	Celular celularSiResumen
	
	@Before
	def void init() {
		celularNoResumen = new Celular
		celularNoResumen.numero = 17256124
		celularNoResumen.nombre = 'Juan Carlos Perez'
		var nokia = new Modelo
		nokia.costo = new BigDecimal(150)
		nokia.descripcion = 'NOKIA'
		nokia.requiereResumenCuenta = false
		celularNoResumen.modeloCelular = nokia 
		celularSiResumen = new Celular
		celularSiResumen.numero = 23563269
		celularSiResumen.nombre = 'Mariana Moretti'
		var nokia11 = new Modelo
		nokia11.costo = new BigDecimal(350)
		nokia11.descripcion = 'NOKIA 11'
		nokia11.requiereResumenCuenta = true
		celularSiResumen.modeloCelular = nokia11
	}
	
	@Test
	def void celularNoRecibeResumenCuenta() {
		assertFalse(celularNoResumen.recibeResumenCuenta)
	}
	
	@Test
	def void celularSiRecibeResumenCuenta() {
		assertTrue(celularSiResumen.recibeResumenCuenta)
	}
	
	@Test
	def void celularCambiaRecibeResumenCuenta() {
		var modeloQueRequiereResumen = new Modelo
		modeloQueRequiereResumen.requiereResumenCuenta = true
		celularNoResumen.modeloCelular = modeloQueRequiereResumen
		assertTrue(celularNoResumen.recibeResumenCuenta)
	}
	
	@Test(expected=typeof(UserException))
	def void celularNumeroGrande() {
		var celularMalo = new Celular
		celularMalo.numero = 891724861
		celularMalo.validar
	}

	@Test(expected=typeof(UserException))
	def void celularNoIngresoNumero() {
		var celularMalo = new Celular
		celularMalo.nombre = "Pepe"
		celularMalo.validar
	}

	@Test(expected=typeof(UserException))
	def void celularNoIngresoNombre() {
		var celularMalo = new Celular
		celularMalo.numero = 19246218
		celularMalo.validar
	}

	@Test(expected=typeof(UserException))
	def void celularNoIngresoModelo() {
		var celularMalo = new Celular
		celularMalo.numero = 19246218
		celularMalo.nombre = "Pepe"
		celularMalo.validar
	}
	
	@Test
	def void celularValidacionOk() {
		celularNoResumen.validar()
	}

}