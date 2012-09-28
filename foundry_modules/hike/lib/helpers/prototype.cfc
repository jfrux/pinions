<cfcomponent
	output="false"
	hint="I provide core prototype functionality through onMissingMethod() and some utility methods.">
 
 
	<cffunction
		name="addPrototypeMethod"
		access="public"
		returntype="any"
		output="false"
		hint="I add the given method to the prototype with the given name.">
 
		<!--- Define arguments. --->
		<cfargument
			name="name"
			type="string"
			required="true"
			hint="I am the name of the method."
			/>
 
		<cfargument
			name="method"
			type="any"
			required="true"
			hint="I am the method being added to the prototype."
			/>
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Get the prototype object for this class. --->
		<cfset local.prototype = this.getPrototype() />
 
		<!--- Add the method to the class prototype. --->
		<cfset local.prototype[ arguments.name ] = arguments.method />
 
		<!--- Return this object reference for chaining. --->
		<cfreturn this />
	</cffunction>
 
 
	<cffunction
		name="clearPrototype"
		access="public"
		returntype="any"
		output="false"
		hint="I clear the prototype properties.">
 
		<!--- Get the protoytpe object and clear its keys. --->
		<cfset structClear( this.getPrototype() ) />
 
		<!--- Return this object reference for chaining. --->
		<cfreturn this />
	</cffunction>
 
 
	<cffunction
		name="getPrototype"
		access="public"
		returntype="struct"
		output="false"
		hint="I return the prototype being used for this class.">
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!---
			When getting the prototype object, check to see if
			we are using this a base class or as a utiltiy class.
			If this is a utility class, the prototype key will exist.
			In either case, this is the meta data for this class -
			NOT of any particular instance. This meta data is shared
			by all instances of the given class.
		--->
		<cfif structKeyExists( this, "__prototype__" )>
 
			<!---
				This is being used as a utility class, not a base
				class. Get the component meta data from the given
				class path.
			--->
			<cfset local.metaData = getComponentMetaData(
				this.__prototype__
				) />
 
		<cfelse>
 
			<!---
				This is being used as a base class. Get the meta
				data of this particular instance class.
			--->
			<cfset local.metaData = getMetaData( this ) />
 
		</cfif>
 
		<!--- Param the prototype property of the meta data. --->
		<cfparam
			name="local.metaData.prototype"
			type="struct"
			default="#structNew()#"
			/>
 
		<!--- Return the prototype struct. --->
		<cfreturn local.metaData.prototype />
	</cffunction>
 
 
	<cffunction
		name="getPrototypeForClass"
		access="public"
		returntype="any"
		output="false"
		hint="I return the prototype being used for the given class.">
 
		<!--- Define arguments. --->
		<cfargument
			name="className"
			type="string"
			required="true"
			hint="I am the name/path of the class for which we are accessing the prototype."
			/>
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!---
			Store this prototype class property on this
			instance - it will be used when accessing the
			prototype object later.
		--->
		<cfset this.__prototype__ = arguments.className />
 
		<!---
			Return this object reference. Going forward,
			the programmer can use this instance to update
			the prototype of the given class.
		--->
		<cfreturn this />
	</cffunction>
 
 
	<cffunction
		name="onMissingMethod"
		access="public"
		returntype="any"
		output="false"
		hint="I am used to route methods into the prototype (if they exist).">
 
		<!--- Define arguments. --->
		<cfargument
			name="missingMethodName"
			type="string"
			required="true"
			hint="I am the name of the missing method."
			/>
 
		<cfargument
			name="missingMethodArguments"
			type="any"
			required="true"
			hint="I am the argument collection used to try an invoke the missing method."
			/>
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!---
			We have to var-scope this variable to allow the use
			of the argumentCollection later on (this is a weird
			compilation error or something).
		--->
		<cfset var prototypeMethod = "" />
 
		<!--- Get the prototype object. --->
		<cfset local.prototype = this.getPrototype() />
 
		<!---
			Get the method reference. If the method doesn't exist,
			just let this aspect throw an error since the code was
			going to break anyway.
		--->
		<cfset prototypeMethod = local.prototype[ arguments.missingMethodName ] />
 
		<!--- Invoke the method. --->
		<cfset local.result = prototypeMethod(
			argumentCollection = arguments.missingMethodArguments
			) />
 
		<!---
			Check to see if we have any arguments (a VOID response
			would have killed the variable).
		--->
		<cfif structKeyExists( local, "result" )>
 
			<!--- Return the prototype method result. --->
			<cfreturn local.result />
 
		<cfelse>
 
			<!--- No prototype response, so just return void. --->
			<cfreturn />
 
		</cfif>
	</cffunction>
 
 
	<cffunction
		name="removePrototypeMethod"
		access="public"
		returntype="any"
		output="false"
		hint="I remove the method with the given name from the clas prototype.">
 
		<!--- Define arguments. --->
		<cfargument
			name="name"
			type="string"
			required="true"
			hint="I am the name of the method being removed."
			/>
 
		<!---
			Delete the key from the prototype. Since this is
			passed by reference, we don't have to re-store it.
		--->
		<cfset structDelete( this.getPrototype(), arguments.name ) />
 
		<!--- Return this object reference for chaining. --->
		<cfreturn this />
	</cffunction>
 
</cfcomponent>