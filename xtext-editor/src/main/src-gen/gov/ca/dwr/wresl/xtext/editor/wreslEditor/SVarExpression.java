/**
 */
package gov.ca.dwr.wresl.xtext.editor.wreslEditor;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>SVar Expression</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link SVarExpression#getExpression <em>Expression</em>}</li>
 * </ul>
 * </p>
 *
 * @see WreslEditorPackage#getSVarExpression()
 * @model
 * @generated
 */
public interface SVarExpression extends SVar
{
  /**
   * Returns the value of the '<em><b>Expression</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Expression</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Expression</em>' containment reference.
   * @see #setExpression(Expression)
   * @see WreslEditorPackage#getSVarExpression_Expression()
   * @model containment="true"
   * @generated
   */
  Expression getExpression();

  /**
   * Sets the value of the '{@link SVarExpression#getExpression <em>Expression</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Expression</em>' containment reference.
   * @see #getExpression()
   * @generated
   */
  void setExpression(Expression value);

} // SVarExpression