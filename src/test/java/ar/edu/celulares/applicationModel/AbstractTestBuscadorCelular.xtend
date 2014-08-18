package ar.edu.celulares.applicationModel

import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.home.HomeModelos
import org.junit.Before
import org.uqbar.commons.utils.ApplicationContext

class AbstractTestBuscadorCelular {

	protected BuscadorCelular searcher

	@Before
	def void init() {
		searcher = new BuscadorCelular
		searcher.nombre = "Dodi"
		ApplicationContext.instance.configureSingleton(typeof(Modelo), new HomeModelos)
	}

}
