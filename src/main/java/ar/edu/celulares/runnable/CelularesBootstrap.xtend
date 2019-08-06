package ar.edu.celulares.runnable

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.repo.RepoCelulares
import ar.edu.celulares.repo.RepoModelos
import org.uqbar.arena.bootstrap.CollectionBasedBootstrap
import org.uqbar.commons.applicationContext.ApplicationContext

class CelularesBootstrap extends CollectionBasedBootstrap {

	new() {
		ApplicationContext.instance.configureSingleton(Modelo, new RepoModelos)
		ApplicationContext.instance.configureSingleton(Celular, new RepoCelulares)
	}

	/**
	 * Inicialización del juego de datos del repositorio
	 * 
	 * Nota: en ejemplos anteriores estaba en el método init
	 * del repo, esto acoplaba innecesariamente el juego de datos
	 * con su repositorio
	 * 
	 */
	override run() {
		val repoModelos = ApplicationContext.instance.getSingleton(Modelo) as RepoModelos
		val repoCelulares = ApplicationContext.instance.getSingleton(Celular) as RepoCelulares

		val nokiaAsha = repoModelos.create("NOKIA ASHA 501", 700f, true)
		val lgOptimusL5 = repoModelos.create("LG OPTIMUS L5 II", 920f, false)
		repoModelos.create("LG OPTIMUS L3 II", 450f, true)
		val nokiaLumia = repoModelos.create("NOKIA LUMIA 625", 350f, true)
		repoModelos.create("MOTOROLA RAZR V3", 350f, false)

		repoCelulares => [
			create("Laura Iturbe", 88022202, nokiaLumia, false)
			create("Julieta Passerini", 45636453, nokiaAsha, false)
			create("Debora Fortini", 45610892, nokiaAsha, true)
			create("Chiara Dodino", 68026976, nokiaAsha, false)
			create("Melina Dodino", 40989911, lgOptimusL5, true)
		]
		
	}

}
