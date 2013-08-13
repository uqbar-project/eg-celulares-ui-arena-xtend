package ar.edu.celulares.domain

import org.uqbar.commons.model.Entity
import org.uqbar.commons.model.ObservableUtils
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.Observable

@Observable
class Celular extends Entity {

	final int MAX_NUMERO = 100000

	@Property Integer id
	@Property Integer numero
	@Property String nombre
	@Property Modelo modeloCelular
	@Property Boolean recibeResumenCuenta = false

	// ********************************************************
	// ** Getters y setters
	// Los getters y setters por default no se deben codificar
	// peeeeeero...
	// en nuestro ejemplo tenemos que modificar la propiedad
	// recibeResumenCuenta en base al modelo de celular seleccionado
	// ********************************************************

	def void setModeloCelular(Modelo unModeloCelular) {
		// para no entrar en loop infinito, en el setter debemos
		// utilizar _ para indicar que nos referimos a la variable
		// que genera xtend para compilar en Java
		this._modeloCelular = unModeloCelular
		// fin comentario
		recibeResumenCuenta = unModeloCelular.requiereResumenCuenta
	}

	def void setRecibeResumenCuenta(boolean siRecibeResumenCuenta) {
		// idem modeloCelular
		this._recibeResumenCuenta = siRecibeResumenCuenta
		// fin comentario _ sobre variable
		ObservableUtils.firePropertyChanged(this, "habilitaResumenCuenta", !habilitaResumenCuenta)
	}

	// ********************************************************
	// ** Validacion
	// ********************************************************
	/**
	 * Valida que el celular esté correctamente cargado
	 */
	def void validar() {
		if (numero == null) {
			throw new UserException("Debe ingresar número")
		}
		if (numero.intValue() <= this.MAX_NUMERO) {
			throw new UserException("El número debe ser mayor a " + this.MAX_NUMERO)
		}
		if (!this.ingresoNombre()) {
			throw new UserException("Debe ingresar nombre")
		}
		if (modeloCelular == null) {
			throw new UserException("Debe ingresar un modelo de celular")
		}
	}

	def boolean ingresoNombre() {
		return !nombre?.trim().equals("")
	}

	// ********************************************************
	// ** Getters y setters
	// ********************************************************
	def getHabilitaResumenCuenta() {
		return !modeloCelular.requiereResumenCuenta
	}

	// ********************************************************
	// ** Misceláneos
	// ********************************************************
	override def String toString() {
		var result = new StringBuffer()
		result.append(nombre ?: "Celular sin nombre")
		if (modeloCelular != null) {
			result.append(" - " + modeloCelular)
		}
		if (numero != null) {
			result.append(" - " + numero)
		}
		if (recibeResumenCuenta) {
			result.append(" - recibe resumen")
		} else {
			result.append(" - no recibe resumen")
		}
		return result.toString()
	}

}
