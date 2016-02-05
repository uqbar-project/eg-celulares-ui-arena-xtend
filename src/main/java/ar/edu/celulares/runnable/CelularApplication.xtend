package ar.edu.celulares.runnable

import ar.edu.celulares.ui.BuscarCelularesWindow
import org.uqbar.arena.Application
import org.uqbar.arena.windows.Window

class CelularApplication extends Application {

	new(CelularesBootstrap bootstrap) {
		super(bootstrap)
	}

	static def void main(String[] args) {
		new CelularApplication(new CelularesBootstrap).start()
	}

	override protected Window<?> createMainWindow() {
		return new BuscarCelularesWindow(this)
	}

}
