/*
 * generated by Xtext
 */
package gov.ca.dwr.wresl.xtext.editor.parser.antlr;

import java.io.InputStream;
import org.eclipse.xtext.parser.antlr.IAntlrTokenFileProvider;

public class WreslEditorAntlrTokenFileProvider implements IAntlrTokenFileProvider {
	
	public InputStream getAntlrTokenFile() {
		ClassLoader classLoader = getClass().getClassLoader();
    	return classLoader.getResourceAsStream("gov/ca/dwr/wresl/xtext/editor/parser/antlr/internal/InternalWreslEditorParser.tokens");
	}
}
