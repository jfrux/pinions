/**
* @name "Console.cfc"
* @author "Joshua F. Rountree"
*
*/
component {
	public any function init(opts = {}) {
		variables.logManager = createObject("java","java.util.logging.LogManager");
		variables.ansi = createObject("java","jlibs.core.lang.Ansi");
		variables.ansiFormatter = createObject("java","jlibs.core.util.logging.AnsiFormatter");
		;
		variables.System = createObject("java","java.lang.System");
		variables.logger = LogManager.getLogManager().getLogger("");
		variables.level = createObject("java","java.util.logging.Level");
		
		logger.setLevel(level.FINEST);

		variables.handler = logger.getHandlers()[1];
		handler.setLevel(level.FINEST);
		handler.setFormatter(AnsiFormatter.init());
		
		this.info("Console.cfc Init");
		this.config("Console.cfc Init");
		this.error("Console.cfc Init");
		this.severe("Console.cfc Init");
		this.warning("Console.cfc Init");
		this.finer("Console.cfc Init");
		this.finest("Console.cfc Init");
		
		return logger;
	}

	public any function log(obj) {
		return variables.logger.log(variables.level.FINEST,arguments.obj);
	}

	public any function info(obj) {
		return variables.logger.log(variables.level.INFO,arguments.obj);
	}

	public any function config(obj) {
		return variables.logger.log(variables.level.CONFIG,arguments.obj);
	}

	public any function error(obj) {
		return variables.logger.log(variables.level.SEVERE,arguments.obj);
	}

	public any function severe(obj) {
		return variables.logger.log(variables.level.SEVERE,arguments.obj);
	}

	public any function warning(obj) {
		return variables.logger.log(variables.level.WARNING,arguments.obj);
	}

	public any function finer(obj) {
		return variables.logger.log(variables.level.FINER,arguments.obj);
	}

	public any function finest(obj) {
		return variables.logger.log(variables.level.FINEST,arguments.obj);
	}
}