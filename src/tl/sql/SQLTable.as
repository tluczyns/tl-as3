package tl.sql {
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.data.SQLConnection;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.events.SQLEvent;
	import flash.data.SQLResult;
	import tl.vspm.EventModel;
	
	public class SQLTable extends EventDispatcher {
		
		static public const DATA_SELECTED: String = "dataSelected";
		static public const DATA_CHANGED: String = "dataChanged";
		static public const FIELD_CHANGED: String = "fieldChanged";
		
		public var sqlStm: SQLStatementEx;
		
		private var nameTable: String;
		private var classItem: Class;
		private var arrNameFieldsTable: Array;
		private var arrTypeFieldsTable: Array;
		private var isAddId: Boolean;
		
		public function SQLTable(dirTable: File, nameTable: String, classItem: Class, arrNameFieldsTable: Array, arrTypeFieldsTable: Array, arrInitData: Array = null, isAddId: Boolean = true /*, startValueForId: int = -1*/): void {
			this.nameTable = nameTable;
			this.classItem = classItem;
			this.arrNameFieldsTable = arrNameFieldsTable;
			this.arrTypeFieldsTable = arrTypeFieldsTable;
			this.isAddId = isAddId;
			//otwiera plik bazy danych (lub tworzy nowy, jak nie istnieje) w katalogu "%katalog_uzytkownika%/dane aplikacji/VisitorsEntriesAndGifts/Local Store"
			if (!dirTable) dirTable = File.applicationStorageDirectory;
			var file: File = dirTable.resolvePath(this.nameTable + ".db"); //lub new File("app-storage:/file.db");
			var isNewFile: Boolean = !file.exists; 
			if (isNewFile) this.openFile(file);
			//otwiera połączenie do bazy danych w tym pliku (plus ewentualne tworzy tabelę 'address', jak jest nowy plik)
			var sqlConn: SQLConnection = new SQLConnection();
			sqlConn.open(file);
			this.sqlStm = new SQLStatementEx(sqlConn, classItem);
			//this.sqlStm.addEventListener(SQLEvent.RESULT, this.onResultSqlStm);
			if (isNewFile) {
				this.createTable();
				//if (startValueForId > -1) this.sqlStm.executeSQL("UPDATE SQLITE_SEQUENCE SET seq = " + startValueForId + " WHERE name = '" + this.nameTable + "'")
				this.initData(arrInitData);
			}
		}
		
		private function openFile(newFile: File): void {
			var fileStream: FileStream = new FileStream();
			fileStream.open(newFile, FileMode.WRITE);
			fileStream.writeUTFBytes("");
			fileStream.close();
		}
		
		private function createTable(): void {
			var sqlQueryCreateTable: String = "CREATE TABLE IF NOT EXISTS '" + unescape(this.nameTable) + "' (";
			var arrNameFieldsTable: Array = this.arrNameFieldsTable;
			var arrTypeFieldsTable: Array = this.arrTypeFieldsTable; 
			if (this.isAddId) {
				arrNameFieldsTable = ["id"].concat(arrNameFieldsTable);
				arrTypeFieldsTable = ["INT PRIMARY KEY AUTOINCREMENT"].concat(arrTypeFieldsTable);
			}
			for (var i:uint = 0; i < arrNameFieldsTable.length; i++) {
				sqlQueryCreateTable += (arrNameFieldsTable[i] + " " + arrTypeFieldsTable[i] + ((i < arrNameFieldsTable.length - 1) ? ", " : ""));
			}
			sqlQueryCreateTable += ")";
			this.sqlStm.executeSQL(sqlQueryCreateTable);
		}
		
		private function initData(arrInitData: Array): void {
			var sqlStartInsertDataTable: String = "INSERT INTO " + this.nameTable + " (";
			for (var j: uint = 0; j < this.arrNameFieldsTable.length; j++) {
				sqlStartInsertDataTable += (this.arrNameFieldsTable[j] + ((j < this.arrNameFieldsTable.length - 1) ? ", " : ""));
			}
			sqlStartInsertDataTable += ") VALUES (";
			if (arrInitData) {
				for (var i: uint = 0; i < arrInitData.length; i++) {
					var sqlInsertDataTable: String = sqlStartInsertDataTable;
					for (j = 0; j < this.arrNameFieldsTable.length; j++)
						sqlInsertDataTable += ("'" + arrInitData[i][j] + "'" + ((j < this.arrNameFieldsTable.length - 1) ? ", " : ""));
					sqlInsertDataTable += ");";
					this.sqlStm.executeSQL(sqlInsertDataTable);	
				}
			}
		}
		
		//pobiera rekordy z bazy, odpalana po starcie aplikacji, operacji INSERT i DELETE i filtrowaniu
		public function getAllData(): void {
			this.sqlStm.executeSQL("SELECT * FROM " + this.nameTable);
		}
		
		/*private function onResultSqlStm(event: SQLEvent): void {
			var sqlResult: SQLResult = this.sqlStm.getResult();
			//trace("sqlResult:", sqlResult.rowsAffected, sqlResult.data)
			if ((sqlResult.data == null) && (sqlResult.rowsAffected > 0)) {
				//była to operacja INSERT lub DELETE (nie zwróciła żadnych danych, a także zmodyfikowała jakiś wiersz), po której poprzez SELECT odświeżamy zawartość DataGrid - może tu nie jest wydajne, ale bezpieczne
				//synchronizacja byłaby niepotrzebnie męcząca - trzeba by było ręcznie uaktualniać zbindowaną tablicę, tutaj robimy to tylko dla operacji UPDATE i to wystarczy 
				this.dispatchEvent(new EventModel(SQLTable.DATA_CHANGED, sqlResult.lastInsertRowID));
				this.getAllData();
			} else { //if (sqlResult.data != null) {
				var dataSQLResult: Array = sqlResult.data;
				if (dataSQLResult == null) dataSQLResult = [];
				//była to operacja SELECT, dispatchujemy event
				for (var i: uint = 0; i < dataSQLResult.length; i++) {
					var objData: EventDispatcher = classItem(dataSQLResult[i]);
					objData.addEventListener(SQLTable.FIELD_CHANGED, this.onFieldChanged);
				}
				this.dispatchEvent(new EventModel(SQLTable.DATA_SELECTED, sqlResult.data));
			}
		}
		
		private function onFieldChanged(e: EventModel): void {
			this.sqlStm.executeSQL("UPDATE " + this.nameTable + " SET " + e.data.field + " = '" + e.data.value + "' WHERE id = '" + e.data.id + "';");
		}*/
		
		public function executeSQL(strSQL: String): void {
			this.sqlStm.executeSQL(strSQL);
		}
		
		public function abort(): void {
			this.sqlStm.cancel();	
		}
		
		public function destroy(): void {
			this.abort()
			//this.sqlStm.removeEventListener(SQLEvent.RESULT, this.onResultSqlStm);
			this.sqlStm.destroy();
		}
		
	}

}