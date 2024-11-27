class Lugar {
    const nombre

    method tieneCantidadParDeLetras() = nombre.length().even()

    method esDivertido() = self.tieneCantidadParDeLetras() && self.esDivertidoExtra()

    method esDivertidoExtra()

    method tieneNombreLargo() = nombre.length() > 10
}


class Ciudad inherits Lugar {
    var cantidadHabitantes
    const atraccionesTuristicas = []
    const decibelesPromedio

    method tieneMuchasAtraccionesTuristicas() = atraccionesTuristicas.size() > 3

    method tieneMuchosHabitantes() = cantidadHabitantes > 100000

    override method esDivertidoExtra() = self.tieneMuchasAtraccionesTuristicas() && self.tieneMuchosHabitantes()

    method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar {
    const extension // En km2
    const fundacion
    const provincia

    method esAntiguo() = fundacion < new Date(year = 1800)

    method esDelLitoral() = ["Entre Ríos", "Corrientes", "Misiones"].contains(provincia)

    override method esDivertidoExtra() = self.esAntiguo() || self.esDelLitoral()

    method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar {
    const tamanioDePlayaPromedio // En metros
    var marPeligroso
    const tienePeatonal

    method tienePlayaGrande() = tamanioDePlayaPromedio > 300

    override method esDivertidoExtra() = self.tienePlayaGrande() && marPeligroso

    method esTranquilo() = !tienePeatonal
}

class Persona {
    var preferenciaDeVacaciones
    var property presupuestoMaximo

    method iriaDeVacacionesA(lugar)

    method precioEsAdecuado(precio) = precio < presupuestoMaximo
}

object preferenciaTranquilidad {
    method esPreferido(lugar) = lugar.esTranquilo()
}

object preferenciaDiversion {
    method esPreferido(lugar) = lugar.esDivertido()
}

object preferenciaRara {
    method esPreferido(lugar) = lugar.tieneNombreLargo()
}

class PreferenciaCompuesta {
    const preferencias = []

    method esPreferido(lugar) = preferencias.any({ preferencia => preferencia.esPreferido(lugar) })
}

class Tour {
    const property fechaDeSalida
    const cantidadDePersonasRequeridas
    const lugaresARecorrer
    const precioPorPersona
    const personas = []

    method agregarPersona(persona) {
        self.verificarPrecioAdecuadoPara(persona)
        self.verificarLugaresPreferidosPor(persona)
        self.verificarCupos()

        personas.add(persona)
    }

    method verificarPrecioAdecuadoPara(persona) {
        if (persona.precioEsAdecuado(precioPorPersona)) {
            throw new DomainException(message = "El precio no es adecuado para la persona")
        }
    }

    method verificarLugaresPreferidosPor(persona) {
        if (persona.precioEsAdecuado(precioPorPersona)) {
            throw new DomainException(message = "El precio no es adecuado para la persona")
        }
    }

    method verificarCupos() {
        if (self.tieneCuposCompletos()) {
            throw new DomainException(message = "Se llego a la cantidad de personas requeridas")
        }
    }

    method sonTodosLosLugaresPreferidosPor(persona) = lugaresARecorrer.all({ lugar => persona.iriaDeVacacionesA(lugar) })

    method darDeBaja(persona) {
        personas.remove(persona)
    }

    method tieneCuposCompletos() = self.cantidadDePersonas() >= cantidadDePersonasRequeridas

    method anioDeSalida() = self.fechaDeSalida().year()

    method cantidadDePersonas() = personas.length()

    method montoTotal() = self.cantidadDePersonas() * precioPorPersona
}

object reporte {
    const tours = []

    method agregarTour(tour) {
        tours.add(tour)
    }

    method toursPendientes() = tours.filter( { tour => !tour.tieneCuposCompletos() } )

    method totalToursConfirmadosEsteAnio() = self.toursDeEsteAnio().sum( { tour => tour.montoTotal() } )

    method toursDeEsteAnio() = tours.filter( { tour => tour.anioDeSalida() == new Date().year() } )
}