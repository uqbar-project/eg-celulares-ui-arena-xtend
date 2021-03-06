package ar.edu.celulares.ui

import ar.edu.celulares.applicationModel.BuscadorCelular
import ar.edu.celulares.domain.Celular
import java.awt.Color
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

/**
 * Ventana de búsqueda de celulares.
 *
 * @see BuscadorCelular el modelo subyacente.
 *
 * @author ?
 */
class BuscarCelularesWindow extends SimpleWindow<BuscadorCelular> {

	new(WindowOwner parent) {
		super(parent, new BuscadorCelular)
		modelObject.search()
		title = "Buscador de Clientes"
		taskDescription = "Ingrese los parámetros de búsqueda"
	}

	/**
	 * El default de la vista es un formulario que permite disparar la búsqueda (invocando con super) Además
	 * le agregamos una grilla con los resultados de esa búsqueda y acciones que pueden hacerse con elementos
	 * de esa búsqueda
	 */
	override createMainTemplate(Panel mainPanel) {
		super.createMainTemplate(mainPanel)

		this.createResultsGrid(mainPanel)
		this.createGridActions(mainPanel)
	}

	// *************************************************************************
	// * FORMULARIO DE BUSQUEDA
	// *************************************************************************
	/**
	 * El panel principal de búsuqeda permite filtrar por número o nombre
	 */
	override void createFormPanel(Panel mainPanel) {
		val searchFormPanel = new Panel(mainPanel) => [
			layout = new ColumnLayout(2)
		]

		new Label(searchFormPanel) => [
			text = "Número"
			foreground = Color.BLUE
		]

		new NumericField(searchFormPanel, false) => [
			// tip: de esta manera se registra el binding
			// anidado y se disparan notificaciones,
			// si al searchFormPanel se le asigna como modelo
			// el objeto example no se disparan 
			value <=> "example.numero"
			width = 200
		]

		new Label(searchFormPanel) => [
			text = "Nombre del cliente"
			foreground = Color.BLUE
		]

		new TextBox(searchFormPanel) => [
			value <=> "example.nombre"
			width = 200
		]
	}

	/**
	 * Acciones asociadas de la pantalla principal. Interesante para ver es cómo funciona el binding que mapea
	 * la acción que se dispara cuando el usuario presiona click Para que el binding sea flexible necesito
	 * decirle objeto al que disparo la acción y el mensaje a enviarle Contra: estoy atado a tener métodos sin
	 * parámetros. Eso me impide poder pasarle parámetros como en el caso del alta/modificación.
	 * Buscar/Limpiar: son acciones que resuelve el modelo (BuscadorCelular) 
	 * Nuevo: necesita disparar una pantalla de alta, entonces lo resuelve la vista (this)
	 *
	 */
	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Buscar"
			onClick([|modelObject.search])
			setAsDefault
			disableOnError
		]

		new Button(actionsPanel) => [
			caption = "Limpiar"
			onClick([|modelObject.clear])
		]

		new Button(actionsPanel) => [
			caption = "Nuevo Celular"
			onClick([|this.crearCelular])
		]
	}

	// *************************************************************************
	// ** RESULTADOS DE LA BUSQUEDA
	// *************************************************************************
	/**
	 * Se crea la grilla en el panel de abajo El binding es: el contenido de la grilla en base a los
	 * resultados de la búsqueda: cuando el usuario presiona Buscar, se actualiza el model, y éste a su vez
	 * dispara la notificación a la grilla que funciona como Observer
	 */
	def protected createResultsGrid(Panel mainPanel) {
		val table = new Table<Celular>(mainPanel, Celular) => [
			items <=> "resultados"
			value <=> "celularSeleccionado"
			numberVisibleRows = 8
		]
		this.describeResultsGrid(table)
	}

	/**
	 * Define las columnas de la grilla Cada columna se puede bindear 1) contra una propiedad del model, como
	 * en el caso del número o el nombre 2) contra un transformer que recibe el model y devuelve un tipo
	 * (generalmente String), como en el caso de Recibe Resumen de Cuenta
	 *
	 */
	def void describeResultsGrid(Table<Celular> table) {
		new Column<Celular>(table) => [
			title = "Nombre"
			fixedSize = 200
			bindContentsToProperty("nombre")
		]

		new Column<Celular>(table) => [
			title = "Número"
			fixedSize = 100
			alignRight
			bindContentsToProperty("numero")
		]

		new Column<Celular>(table) => [
			title = "Modelo"
			fixedSize = 200
			bindContentsToProperty("modeloCelular")
		]

		new Column<Celular>(table) => [
			title = "Recibe resumen de cuenta"
			fixedSize = 50
			bindContentsToProperty("recibeResumenCuenta").transformer = 
			 [ Boolean recibe | 
			 	if (recibe) "SI" else "NO"
			 ]
			bindBackground("recibeResumenCuenta").transformer =
				[ Boolean recibe | if (recibe) Color.GREEN else Color.RED ]
		]
	}

	def void createGridActions(Panel mainPanel) {
		// Deshabilitar los botones si no hay ningún elemento seleccionado en la grilla.
		val elementSelected = new NotNullObservable("celularSeleccionado")
		
		val actionsPanel = new Panel(mainPanel).layout = new HorizontalLayout
		
		new Button(actionsPanel) => [
			caption = "Editar"
			onClick([|this.modificarCelular])
			bindEnabled(elementSelected)
		]

		new Button(actionsPanel) => [
			caption = "Borrar"
			onClick([|modelObject.eliminarCelularSeleccionado])
			bindEnabled(elementSelected)
		]
	}

	// ********************************************************
	// ** Acciones
	// ********************************************************
	def void crearCelular() {
		val celular = new Celular
		new CrearCelularWindow(this, celular) => [
			onAccept[this.modelObject.crearCelular(celular)]
			open
		]
	}

	def void modificarCelular() {
		new EditarCelularWindow(this, modelObject.celularSeleccionado) => [
			onAccept[
				this.modelObject => [
					actualizarSeleccionado
					search
				]
			]
			open
		]
	}
}
