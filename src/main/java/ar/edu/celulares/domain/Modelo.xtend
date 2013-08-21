package ar.edu.celulares.domain

import java.math.BigDecimal
import org.uqbar.commons.model.Entity
import org.uqbar.commons.utils.Observable

@Observable
class Modelo extends Entity {
	@Property String descripcion
	@Property BigDecimal costo
	@Property Boolean requiereResumenCuenta // FED: boolean tiene problemas

	def getDescripcionEntera() {
		descripcion + " ($ " + costo + ")"
	}

	override def toString() {
		descripcionEntera
	}
}
