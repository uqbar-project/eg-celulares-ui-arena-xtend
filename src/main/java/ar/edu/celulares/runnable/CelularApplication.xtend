package ar.edu.celulares.runnable

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.home.HomeCelulares
import ar.edu.celulares.home.HomeModelos
import ar.edu.celulares.ui.BuscarCelularesWindow
import org.uqbar.arena.Application
import org.uqbar.arena.windows.Window
import org.uqbar.commons.utils.ApplicationContext

class CelularApplication extends Application {
	
	static def void main(String[] args) { 
		new CelularApplication().start()
	}

	override protected Window<?> createMainWindow() {
		ApplicationContext.instance.configureSingleton(typeof(Modelo), new HomeModelos)
		ApplicationContext.instance.configureSingleton(typeof(Celular), new HomeCelulares)
		return new BuscarCelularesWindow(this)
	}
}
