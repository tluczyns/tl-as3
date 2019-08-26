//klasa rozszerzająca SQLStatement
package tl.sql {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	
	public class SQLStatementEx extends SQLStatement {
	
		public function SQLStatementEx(sqlConnection: SQLConnection, itemClass: Class) {
			super();
			this.sqlConnection = sqlConnection;
			this.itemClass = itemClass;
		}
		
		//funkcja umożliwiająca wykonanie sqla w jednej linijce kodu
		public function executeSQL(strSQL: String, parameters: Array = null):void {
			this.text = strSQL;
			for (var nameParameter: String in this.parameters)
				delete this.parameters[nameParameter];
			if (parameters != null) {
				for (var i: uint; i < parameters.length; i++) {
					var parameter: Array = parameters[i];
					this.parameters[":" + parameter[0]] = parameter[1];
				}
			}
			this.execute();
		}
		
		public function destroy(): void {
			this.sqlConnection.close();
			this.sqlConnection = null;
		}
	}
}