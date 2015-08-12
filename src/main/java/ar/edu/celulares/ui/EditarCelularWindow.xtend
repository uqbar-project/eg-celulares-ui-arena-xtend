package ar.edu.celulares.ui

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.home.HomeCelulares
import ar.edu.celulares.home.HomeModelos
import org.uqbar.arena.aop.windows.TransactionalDialog
import org.uqbar.arena.bindings.ObservableProperty
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.utils.ApplicationContext

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
		new TextBox(form) => [
			bindValueToProperty("numero")
			width = 100
		]
			
		new Label(form).text = "Nombre del cliente"
		
		new TextBox(form) => [
			bindValueToProperty("nombre")
			width = 200	
		]
		
		new Label(form).text = "Modelo del aparato"
		
		new Selector<Modelo>(form) => [
			allowNull(false)
			bindValueToProperty("Celular")
			val propiedadModelos = bindItems(new ObservableProperty(homeModelos, "modelos"))
			propiedadModelos.adapter = new PropertyAdapter(typeof(Modelo), "descripcionEntera")
		]
		
		new Label(form).text = "Recibe resumen cuenta en domicilio"
		
		new CheckBox(form) => [
			bindEnabledToProperty("habilitaResumenCuenta")
			bindValueToProperty("recibeResumenCuenta")
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

	def getHomeCelulares() {
		ApplicationContext.instance.getSingleton(typeof(Celular)) as HomeCelulares
	}

	def getHomeModelos() {
		ApplicationContext.instance.getSingleton(typeof(Modelo)) as HomeModelos
	}

	override executeTask() {
		if (modelObject.isNew) {
			homeCelulares.create(modelObject)
		} else {
			homeCelulares.update(modelObject)
		}
		super.executeTask()
	}
	
}
