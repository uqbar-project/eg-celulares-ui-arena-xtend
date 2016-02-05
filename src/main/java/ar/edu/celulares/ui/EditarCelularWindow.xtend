package ar.edu.celulares.ui

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.repo.RepoCelulares
import ar.edu.celulares.repo.RepoModelos
import org.uqbar.arena.aop.windows.TransactionalDialog
import org.uqbar.arena.bindings.ObservableProperty
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.utils.ApplicationContext

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditarCelularWindow extends TransactionalDialog<Celular> {

	new(WindowOwner owner, Celular model) {
		super(owner, model)
		title = defaultTitle
	}

	def defaultTitle() {
		"Cambio de datos del cliente"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		val form = new Panel(mainPanel).layout = new ColumnLayout(2)
		 
		new Label(form).text = "Número"
		
		/**
		 * Primera forma de binding desde xtend
		 * Equivale a hacer bindValueToProperty("numero")
		 * No se hace chequeo en tiempo de compilación, sino en runtime
		 * Es un shortcut interesante definiendo el operator_spaceship
		 * No funciona en Java :( 
		 */
		new NumericField(form) => [
			value <=> "numero"
			width = 100
		]
			
		new Label(form).text = "Nombre del cliente"
		
		new TextBox(form) => [
			value <=> "nombre"
			width = 200	
		]
		
		new Label(form).text = "Modelo del aparato"
		
		/**
		 * Segunda forma de binding
		 * Un método bindValueToProperty que funciona
		 * como facade o builder, para construir un 
		 * binding entre una propiedad de un modelo
		 * y la propiedad value de la vista
		 * Ventaja: funciona en Java y en Xtend
		 */
		new Selector<Modelo>(form) => [
			allowNull(false)
			bindValueToProperty("modeloCelular")
			val propiedadModelos = bindItems(new ObservableProperty(repoModelos, "modelos"))
			propiedadModelos.adaptWith(typeof(Modelo), "descripcionEntera") // opción A
			//propiedadModelos.adapter = new PropertyAdapter(typeof(Modelo), "descripcionEntera") // opción B
		]
		
		new Label(form).text = "Recibe resumen cuenta en domicilio"

		/**
		 * Tercer tipo de binding, utilizando bloques
		 * ventaja: se puede validar en tiempo de compilación
		 * aunque es un poco más engorroso de definir
		 * Equivale a hacer sobre el checkbox: 
		 * bindValueToProperty("recibeResumenCuenta")
		 */		
		new CheckBox(form) => [
			enabled <=> [ Celular c | c.habilitaResumenCuenta ]
			value <=> [ Celular c | c.recibeResumenCuenta ]
		]		
	}

	override protected void addActions(Panel actions) {
		new Button(actions)
			.setCaption("Aceptar")
			.onClick [|this.accept]
			.setAsDefault.disableOnError

		new Button(actions) //
			.setCaption("Cancelar")
			.onClick [|
				this.cancel
			]
	}

	def getRepoCelulares() {
		ApplicationContext.instance.getSingleton(typeof(Celular)) as RepoCelulares
	}

	def getRepoModelos() {
		ApplicationContext.instance.getSingleton(typeof(Modelo)) as RepoModelos
	}

	override executeTask() {
		if (modelObject.isNew) {
			repoCelulares.create(modelObject)
		} else {
			repoCelulares.update(modelObject)
		}
		super.executeTask()
	}
	
}
