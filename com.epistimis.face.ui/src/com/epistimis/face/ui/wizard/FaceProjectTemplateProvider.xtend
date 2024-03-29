/*
 * generated by Xtext 2.33.0
 */
/*
 * Copyright (c) 2022 - 2024 Epistimis LLC (http://www.epistimis.com).
 */
package com.epistimis.face.ui.wizard


import org.eclipse.core.runtime.Status
//import org.eclipse.jdt.core.JavaCore
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.util.PluginProjectFactory
import org.eclipse.xtext.ui.wizard.template.IProjectGenerator
import org.eclipse.xtext.ui.wizard.template.IProjectTemplateProvider
import org.eclipse.xtext.ui.wizard.template.ProjectTemplate

import static org.eclipse.core.runtime.IStatus.*
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.ui.wizard.template.StringTemplateVariable

/**
 * Create a list with all project templates to be shown in the template new project wizard.
 * 
 * Each template is able to generate one or more projects. Each project can be configured such that any number of files are included.
 */
class FaceProjectTemplateProvider implements IProjectTemplateProvider {
	override getProjectTemplates() {
		#[new HelloWorldProject]
	}
}

@ProjectTemplate(label="Basic FACE Model", icon="project_template.png", description="<p><b>Basic FACE Model</b></p>
<p>This creates a basic FACE model. You can set a parameter to modify the content in the generated file
and a parameter to set the package the file is created in.</p>")
final class HelloWorldProject {
	val advanced = check("Advanced:", false)
	val advancedGroup = group("Properties")
	val name = combo("Face:", #["FACE Model", "UoP Model", "Integration Model"], "Initial focus of the new Model", advancedGroup)
	val path = text("Package:", "", "The package path to place the files in", advancedGroup)

	override protected updateVariables() {
		name.enabled = advanced.value
		path.enabled = advanced.value
		if (!advanced.value) {
			name.value = "FACE Model"
			path.value = ""
		}
	}

	override protected validate() {
		if (path.value.matches('[a-z][a-z0-9_]*(/[a-z][a-z0-9_]*)*'))
			null
		else
			new Status(ERROR, "Wizard", "'" + path + "' is not a valid package name")
	}

	override generateProjects(IProjectGenerator generator) {
		generator.generate(new PluginProjectFactory => [
			projectName = projectInfo.projectName
			location = projectInfo.locationPath
			projectNatures += #[
				//"org.eclipse.sirius.nature.modelingproject", // must generate an .aird file along with this.
				"org.eclipse.ocl.pivot.ui.oclnature",
				// <nature>org.eclipse.jdt.core.javanature</nature>
//				JavaCore.NATURE_ID, 
//				"org.eclipse.pde.PluginNature", 
				XtextProjectHelper.NATURE_ID
			]
			builderIds += #[
//				JavaCore.BUILDER_ID, 
				"org.eclipse.ocl.pivot.ui.oclbuilder",
				XtextProjectHelper.BUILDER_ID
			]
			folders += "src-gen"

			if (name.value == "FACE Model") {
				addFile('''src/«path»/FaceModel.face''', '''
					/*
					 * This is an example model
					 */
					am ArchitectureModel "description of the Architecture model" {
						/*
						 *Add Data, UoP and/or Integration Models here
					
						*/
						
					}
				''')
				//addFile('''representations.aird''', representationsFileContent(path, "FaceModel"));
			} else if (name.value == "UoP Model") {
				addFile('''src/«path»/UoPModel.face''', '''
					/*
					 * This is an example model
					 */
					 am ArchitectureModel "description of the Architecture model"{
					 	
					 	um UoPModel "description of the UoP model" {
					 		/*
					 		*Add Portable Components, Platform Specific Components, etc. here
					 	*/
					 	}
					 }				
				''')
				//addFile('''representations.aird''', representationsFileContent(path, "UoPModel"));
			} else if (name.value == "Integration Model") {
				addFile('''src/«path»/IntegrationModel.face''', '''
					/*
					 * This is an example model
					 */
					am ArchitectureModel "description of the Architecture model"{
						
						im IntegrationModel "description of the Integration model" {
							/*
							 *Add IntegrationContext, UoPInstance, and TranportChannel elements  here
							*/					
							  }
					}
				''')
				//addFile('''representations.aird''', representationsFileContent(path, "IntegrationModel"));
			} else {
				addFile('''src/«path»/FaceModel.face''', '''
					/*
					 * This is an example model
					 */
					am ArchitectureModel "description of the Architecture model" {
						/*
						 *Add Data, UoP and/or Integration Models here
					
						*/
						
					}
				''')
				//addFile('''representations.aird''', representationsFileContent(path, "FaceModel"));
			}

		])
	}

	/**
	 * TODO: This assumes a particular version of something (15.2.0.202303281325). Needs to be updated to some constant that returns the current version.
	 */
	def representationsFileContent(StringTemplateVariable path, String fname) {
		val uid = EcoreUtil.generateUUID()
		return '''
			<?xml version="1.0" encoding="UTF-8"?>
			<viewpoint:DAnalysis xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:viewpoint="http://www.eclipse.org/sirius/1.1.0" uid="«uid»" 
				version="15.2.0.202303281325">
				 <semanticResources>src/«path»/«fname».face</semanticResources>
			</viewpoint:DAnalysis>
			
		'''
	}
}
