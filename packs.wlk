class Pack {
  var property duracionEnDias
  var property precioBase
  const property beneficios = []
  var property coordinador
  
  method agregarBeneficio(unBeneficio) {
    beneficios.add(unBeneficio)
  }
  
  method quitarBeneficio(unBeneficio) {
    beneficios.remove(unBeneficio)
  }
  
  method costoFinal() = precioBase + beneficios.filter({ unBeneficio => unBeneficio.estaVigente() }).sum(
    { beneficioVigente => beneficioVigente.costo() }
  )
  
  method esPremium()
}

class PackNacional inherits Pack {
  const property provinciaDeDestino
  const property actividades = []
  
  method agregarActividad(unaActividad) {
    actividades.add(unaActividad)
  }
  
  method quitarActividad(unaActividad) {
    actividades.remove(unaActividad)
  }
  
  override method esPremium() = (duracionEnDias > 10) and coordinador.esAltamenteCalificado()
}

class PackInternacional inherits Pack {
  const property paisDeDestino
  var property cantidadDeEscalas
  var property esDeInteres
  
  override method costoFinal() = super() * 1.2
  
  override method esPremium() = (esDeInteres and (duracionEnDias > 20)) and (cantidadDeEscalas == 0)
}

class Coordinador {
  var cantidadDeViajes
  var property estaMotivado
  var aniosDeExperiencia
  var rol
  const rolesValidos = #{guia, asistenteLogistico, acompaniante}
  
  method cantidadDeViajes() = cantidadDeViajes
  
  method sumarViaje() {
    cantidadDeViajes += 1
  }
  
  method aniosDeExperiencia() = aniosDeExperiencia
  
  method sumarAnioDeExperiencia() {
    aniosDeExperiencia += 1
  }
  
  method rol() = rol
  
  method rol(unRol) {
    if (not rolesValidos.contains(unRol)) {
      throw new Exception(message = "El rol debe ser guia, asistente logístico o acompañante")
      self.error("El rol debe ser guia, asistente logístico o acompañante")
    }
    rol = unRol
  }
  
  method esAltamenteCalificado() = (cantidadDeViajes > 20) and rol.condicionAdicional(self)
}

object guia {
  method condicionAdicional(unCoordinador) = unCoordinador.estaMotivado()
}

object asistenteLogistico {
  method condicionAdicional(unCoordinador) = unCoordinador.aniosDeExperiencia() >= 3
}

object acompaniante {
  method condicionAdicional(unCoordinador) = true
}

class Beneficio {
  const property tipo
  var property costo
  var estaVigente
  
  method estaVigente() = estaVigente
  
  method ponerVigente() {
    estaVigente = true
  }
  
  method dejarDeEstarVigente() {
    estaVigente = false
  }
}

class PackProvincial inherits PackNacional {
  var property cantidadDeCiudades
  
  override method esPremium() = ((actividades.size() >= 4) and (cantidadDeCiudades > 5)) and (beneficios.count(
    { unBeneficio => unBeneficio.estaVigente() }
  ) >= 3)
  
  override method costoFinal() = super() * if (self.esPremium()) 1.05 else 1
}