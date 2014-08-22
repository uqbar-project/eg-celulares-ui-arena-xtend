package ar.edu.celulares.applicationModel

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.home.HomeCelulares
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.commons.utils.ApplicationContext

class TestBuscadorCelular extends AbstractTestBuscadorCelular {

	BuscadorCelular buscadorFallido
	
	@Before
	override void init() {
		super.init()
		buscadorFallido = new BuscadorCelular
		buscadorFallido.nombre = "XXXX"
		ApplicationContext.instance.configureSingleton(typeof(Celular), new HomeCelulares)
	}

	@Test
	def void buscarSinResultados() {
		buscadorFallido.search
		Assert.assertEquals(0, buscadorFallido.resultados.size)
	}
	
	@Test
	def void buscarDodinos() {
		searcher.search
		Assert.assertEquals(2, searcher.resultados.size)
	}

	@Test
	def void buscarDodinosConNumeroErroneo() {
		searcher.numero = 17715274
		searcher.search
		Assert.assertEquals(0, searcher.resultados.size)
	}

}
