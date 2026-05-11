# Presentación — Sistema Control de Almuerzos

---

## Versión 1: Para líder de IT (Roemmers)

*Presentación informal, ~10 minutos. Tono: directo, técnico, con foco en IA y metodología.*

---

Buenas, te cuento un poco de mí y después te muestro el sistema.

Trabajo en el comedor de Roemmers hace varios años. Soy el que está del otro lado del mostrador cuando entrás a almorzar. Y desde hace un tiempo también estoy estudiando la Tecnicatura en Programación en la UTN de General Pacheco — 17 materias aprobadas, promedio casi nueve, me quedan pocas para terminar.

El motivo de estar acá hoy tiene que ver con haber cruzado los dos mundos.

---

**El problema que identifiqué**

El sistema de registro actual funciona, sí. Pero tiene varios puntos de falla que yo veo todos los días: el QR que no escanea, el código numérico de respaldo, la lista en papel como último recurso. En hora pico eso genera fila, demora y datos inconsistentes al cierre del día.

Lo que noté es que la infraestructura RFID ya existe en el edificio — se usa para otros accesos. Eso me dio la idea: ¿por qué no aprovecharla para el comedor también?

---

**Lo que construí**

Construí un sistema web completo en ASP.NET Core MVC con .NET 9. El flujo es simple: el empleado acerca su credencial a un lector RFID Bluetooth conectado a la tablet, el sistema valida en tiempo real, registra el almuerzo y confirma en pantalla. Sin celular, sin QR, sin papel.

Técnicamente está implementado con ASP.NET Core MVC, Entity Framework Core 9 con Fluent API, ASP.NET Core Identity para autenticación y roles, SQL Server con stored procedures y triggers, QuestPDF para reportes en PDF y MailKit para envío por email. Está desplegado en Azure App Service con Azure SQL Database, a escala real: 504 empleados en 6 empresas.

---

**El rol de la IA en el desarrollo — y en mi carrera**

Acá quiero ser transparente y también hablarte de algo que creo que es relevante para una conversación IT.

Antes de este proyecto, desarrollé el sistema original en Windows Forms completamente solo, sin ninguna asistencia de IA. Ese lo domino de punta a punta.

Para esta versión web usé una metodología que se llama Agentic Coding: yo dirigí la arquitectura, definí las decisiones técnicas clave y revisé y aprobé cada cambio. La implementación fue asistida por Claude Code de Anthropic. El proceso está documentado commit a commit en 54 guías en el repositorio — podés ver exactamente qué decidí yo y qué generó la herramienta.

Esto no es copiar código de ChatGPT. Es un modelo de trabajo donde el desarrollador actúa como arquitecto y la IA como par de programación de alta velocidad. Es la dirección a la que va la industria, y es el enfoque en el que quiero especializarme cuando egrese.

Para el desarrollo también usé los beneficios del GitHub Student Developer Pack: acceso a GitHub Copilot para autocompletado en tiempo real, créditos de Azure para el deploy, y varias herramientas de la suite de JetBrains. Todo eso permitió hacer más con menos tiempo y a costo cero.

---

**Por qué creo que puede ser útil**

No vine a presentar una idea de hobby. Vine a mostrar un sistema que resuelve un problema real que existe acá, construido con tecnología moderna, desplegado en la nube y funcionando hoy.

La inversión en hardware es mínima: un lector RFID Bluetooth cuesta alrededor de 30 dólares. El resto ya está.

Me gustaría saber qué pensás, si ves algún obstáculo desde el lado IT, y si hay algo del sistema que quieras ver en detalle.

---
---

## Versión 2: Para líder de operaciones/gastronomía (Southex)

*Presentación informal, ~10 minutos. Tono: cercano, sin tecnicismos. La persona conoce a Facundo laboralmente, sabe que trabaja en gastronomía, pero no sabe que estudia programación.*

---

Mirá, te quiero contar algo que no sabés de mí, y mostrarte algo que creo que puede ser interesante para Southex.

Estoy estudiando programación en la UTN. Llevo tres años, me quedan pocas materias para terminar la tecnicatura. Y lo que te quiero mostrar hoy es un sistema que desarrollé yo.

---

**Lo que construí y dónde está funcionando**

Construí un sistema digital de registro de comensales para comedores corporativos. Ya está funcionando: está implementado en el comedor de Laboratorios Roemmers, y ese fue el punto de partida.

El sistema funciona así: el empleado acerca su tarjeta a un pequeño lector conectado a una tablet, y en menos de un segundo queda registrado. No necesita celular, no necesita QR, no necesita nada más que su credencial habitual.

Pero el registro es solo la parte visible. Lo que está atrás es lo que me parece más valioso:

- El sistema genera reportes automáticos de asistencia por empresa, por día, por período.
- Esos reportes se exportan a PDF o se envían por email directamente desde la pantalla.
- Hay estadísticas de cobertura — cuántos comieron versus cuántos se esperaban.
- Todo eso en tiempo real, sin que nadie tenga que armar una planilla a mano.

Para el personal de gastronomía, eso significa información lista para la facturación y el cierre del servicio sin trabajo adicional.

---

**Por qué Southex**

El sistema no está diseñado para un solo comedor. Está diseñado para funcionar en cualquier comedor corporativo, con cualquier cantidad de empresas y empleados. Roemmers fue el caso inicial para probarlo a escala, pero la arquitectura es la misma que necesitaría cualquier operación como las que maneja Southex.

Pienso que hay una oportunidad real acá. Y no solo con este sistema.

Ustedes usan Polaris. Conozco el sistema y conozco los procesos — los viví durante más de diez años desde adentro. Hay procesos que hoy se hacen a mano o con herramientas genéricas que podrían estar mucho más automatizados. El tema de las recetas, por ejemplo: la gestión de recetas es algo que casi ningún sistema gastronómico resuelve bien, y es un problema que conozco en detalle.

Tengo ideas concretas para construir herramientas que reemplacen o complementen lo que hoy hace Polaris — y la capacidad técnica para hacerlo.

---

**Lo que te estoy pidiendo**

Sé que estás en una posición donde podés conectarme con el área de sistemas de Southex. Eso es lo que te pido.

No solo porque quiero desarrollar software — sino porque creo que alguien que tiene más de diez años en gastronomía y además sabe programar es un perfil difícil de encontrar. Entiendo los procesos desde adentro. Sé qué duele, qué lleva tiempo, qué se podría hacer mejor. Y tengo las herramientas para construirlo.

Si me das esa conexión, puedo mostrarle al equipo de sistemas lo mismo que te estoy mostrando a vos, con el detalle técnico que corresponde.

¿Qué te parece?
