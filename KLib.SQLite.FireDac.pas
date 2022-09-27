{
  KLib Version = 3.0
  The Clear BSD License

  Copyright (c) 2020 by Karol De Nery Ortiz LLave. All rights reserved.
  zitrokarol@gmail.com

  Redistribution and use in source and binary forms, with or without
  modification, are permitted (subject to the limitations in the disclaimer
  below) provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  * Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

  NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
  THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
}

unit KLib.SQLite.FireDac;

interface

uses
  KLib.Constants,
  FireDAC.Comp.Client;

type

  T_Query = class(FireDAC.Comp.Client.TFDQuery)
  end;

  T_Connection = class(FireDAC.Comp.Client.TFDConnection)
  private
  public
  end;

procedure backup(sourceDatabase: string; destinationDatabase: string);

function _getSQLiteTConnection(database: string; password: string = EMPTY_STRING): T_Connection;

//function getValidSQLiteTFDConnection(SQLiteCredentials: TSQLiteCredentials): TFDConnection;
function getSQLiteTFDConnection(database: string; password: string = EMPTY_STRING): TFDConnection;

implementation

uses
  KLib.SQLite.Validate,
  Klib.Utils, KLib.Windows,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDac.DApt,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  System.SysUtils;

procedure backup(sourceDatabase: string; destinationDatabase: string);
var
  _FDSQLiteBackup: TFDSQLiteBackup;
begin
  _FDSQLiteBackup := TFDSQLiteBackup.Create(nil);
  try
    with _FDSQLiteBackup do
    begin
      DriverLink := TFDPhysSQLiteDriverLink.Create(nil);
      Database := sourceDatabase;
      DestDatabase := destinationDatabase;
    end;
    _FDSQLiteBackup.Backup;
  finally
    FreeAndNil(_FDSQLiteBackup);
  end;
end;

function _getSQLiteTConnection(database: string; password: string = EMPTY_STRING): T_Connection;
var
  _FDConnection: TFDConnection;
  connection: T_Connection;
begin
  _FDConnection := getSQLiteTFDConnection(database, password);
  connection := T_Connection(_FDConnection);
  Result := connection;
end;

//function getValidSQLiteTFDConnection(SQLiteCredentials: TSQLiteCredentials): TFDConnection;
//var
//  connection: TFDConnection;
//begin
////  validateSQLiteCredentials(SQLiteCredentials);
//  connection := getSQLiteTFDConnection(SQLiteCredentials);
//  Result := connection;
//end;

function getSQLiteTFDConnection(database: string; password: string = EMPTY_STRING): TFDConnection;
var
  connection: TFDConnection;

  _database: string;
begin
  _database := database;
  if not checkIfIsAPath(database) then
  begin
    _database := getCombinedPathWithCurrentDir(_database);
  end;

  connection := TFDConnection.Create(nil);
  with connection do
  begin
    LoginPrompt := false;
    Params.Clear;
    Params.Add('DriverID=SQLite');
    Params.Database := _database;
    //    Values['Password'] := password; //TODO
  end;

  Result := connection;
end;

end.
