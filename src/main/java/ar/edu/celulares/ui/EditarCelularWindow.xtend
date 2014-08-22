package ar.edu.celulares.ui

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.home.HomeCelulares
import ar.edu.celulares.home.HomeModelos
import org.uqbar.arena.bindings.ObservableProperty
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.utils.ApplicationContext

class EditarCelularWindow extends Dialog<Celular> {

	Celular original
	
	new(WindowOwner owner, Celular model) {
		super(owner, model)
		original = model.clone() as Celular
	}

	override protected createFormPanel(Panel mainPanel) {
		val form = new Panel(mainPanel)
		form.layout = new ColumnLayout(2)
		new Label(form).text = "Número"
		new TextBox(form)
			//.withFilter [ event | StringUtils::isNumeric(event.potentialTextResult) ]
			.bindValueToProperty("numero")
		
		new Label(form).text = "Nombre del cliente"
		new TextBox(form).bindValueToProperty("nombre")
		new Label(form).text = "Modelo del aparato"
		val selectorModelo = new Selector<Modelo>(form)
		selectorModelo.allowNull(false)
		selectorModelo.bindValueToProperty("modeloCelular")
		var propiedadModelos = selectorModelo.bindItems(new ObservableProperty(homeModelos, "modelos"))
		propiedadModelos.adapter = new PropertyAdapter(typeof(Modelo), "descripcionEntera")
		new Label(form).text = "Recibe resumen cuenta en domicilio"
		var checkResumen = new CheckBox(form)
		checkResumen.bindEnabledToProperty("habilitaResumenCuenta")
		checkResumen.bindValueToProperty("recibeResumenCuenta")
	}

	override protected void addActions(Panel actions) {
		new Button(actions)
			.setCaption("Aceptar")
			.onClick [|this.accept]
			.setAsDefault.disableOnError

		new Button(actions) //
			.setCaption("Cancelar")
			.onClick [|
				original.copiarA(this.modelObject)
				this.cancel
			]
	}

	def getHomeCelulares() {
		ApplicationContext.instance.getSingleton(typeof(Celular)) as HomeCelulares
	}

	def getHomeModelos() {
		ApplicationContext::instance.getSingleton(typeof(Modelo)) as HomeModelos
	}

}
