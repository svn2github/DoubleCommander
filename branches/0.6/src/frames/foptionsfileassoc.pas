{
    Double Commander
    -------------------------------------------------------------------------
    File associations configuration

    Copyright (C) 2008-2009  Koblov Alexander (Alexx2000@mail.ru)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit fOptionsFileAssoc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, EditBtn, uExts, ExtDlgs,
  Menus, fOptionsFrame;

type

  { TfrmOptionsFileAssoc }

  TfrmOptionsFileAssoc = class(TOptionsEditor)
    btnAddAct: TButton;
    btnAddExt: TButton;
    btnAddNewType: TButton;
    btnDownAct: TButton;
    btnRemoveIcon: TSpeedButton;
    btnUpAct: TButton;
    btnRemoveAct: TButton;
    btnRemoveExt: TButton;
    btnRemoveType: TButton;
    btnRenameType: TButton;
    edbAction: TEditButton;
    edtIconFileName: TEdit;
    fneCommand: TFileNameEdit;
    gbFileTypes: TGroupBox;
    gbIcon: TGroupBox;
    gbExts: TGroupBox;
    gbActions: TGroupBox;
    lblAction: TLabel;
    lblCommand: TLabel;
    lbActions: TListBox;
    lbExts: TListBox;
    lbFileTypes: TListBox;
    miFullPath: TMenuItem;
    miFilePath: TMenuItem;
    miFileName: TMenuItem;
    miGetOutputFromCommand: TMenuItem;
    miShell: TMenuItem;
    miViewer: TMenuItem;
    miVfs: TMenuItem;
    miEditor: TMenuItem;
    miEdit: TMenuItem;
    miView: TMenuItem;
    miOpen: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    pnlLeftSettings: TPanel;
    pnlActsEdits: TPanel;
    pnlActsButtons: TPanel;
    pnlExtsButtons: TPanel;
    pnlRightSettings: TPanel;
    pnlSettings: TPanel;
    pmActions: TPopupMenu;
    pmCommands: TPopupMenu;
    sbtnIcon: TSpeedButton;
    btnCommands: TSpeedButton;
    procedure btnActionsClick(Sender: TObject);
    procedure btnAddActClick(Sender: TObject);
    procedure btnAddExtClick(Sender: TObject);
    procedure btnAddNewTypeClick(Sender: TObject);
    procedure btnCommandsClick(Sender: TObject);
    procedure btnDownActClick(Sender: TObject);
    procedure btnRemoveActClick(Sender: TObject);
    procedure btnRemoveExtClick(Sender: TObject);
    procedure btnRemoveTypeClick(Sender: TObject);
    procedure btnRemoveTypeResize(Sender: TObject);
    procedure btnRenameTypeClick(Sender: TObject);
    procedure btnRenameTypeResize(Sender: TObject);
    procedure btnUpActClick(Sender: TObject);
    procedure edtIconFileNameChange(Sender: TObject);
    procedure fneCommandAcceptFileName(Sender: TObject; var Value: String);
    procedure lbActionsSelectionChange(Sender: TObject; User: boolean);
    procedure lbExtsSelectionChange(Sender: TObject; User: boolean);
    procedure lbFileTypesDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure lbFileTypesSelectionChange(Sender: TObject; User: boolean);
    procedure edtActionChange(Sender: TObject);
    procedure fneCommandChange(Sender: TObject);
    procedure miActionsClick(Sender: TObject);
    procedure miCommandsClick(Sender: TObject);
    procedure pnlRightSettingsResize(Sender: TObject);
    procedure pnlSettingsResize(Sender: TObject);
    procedure sbtnIconClick(Sender: TObject);
    procedure btnRemoveIconClick(Sender: TObject);

  private
    Exts : TExts;
    FUpdatingControls: Boolean;
    procedure UpdateEnabledButtons;
    {en
       Frees icon cached in lbFileTypes.Items.Objects[Index].
    }
    procedure FreeIcon(iIndex: Integer);
    procedure SetIconFileName(const sFileName: String);
    procedure SetMinimumSize;

  protected
    procedure Init; override;
    procedure Done; override;
    procedure Load; override;
    function Save: TOptionsEditorSaveFlags; override;
  public
    class function GetIconIndex: Integer; override;
    class function GetTitle: String; override;
  end;

implementation

{$R *.lfm}

uses
  Math, LCLType, uGlobsPaths, uGlobs, uPixMapManager, uLng, uDCUtils,
  DCOSUtils, DCStrUtils;

{ TfrmOptionsFileAssoc }

procedure TfrmOptionsFileAssoc.Init;
begin
  inherited Init;
  Exts := TExts.Create;
  FUpdatingControls := False;
end;

procedure TfrmOptionsFileAssoc.Done;
var
  I: Integer;
begin
  for I := 0 to lbFileTypes.Items.Count - 1 do
    FreeIcon(I);
  FreeAndNil(Exts);
  inherited Done;
end;

procedure TfrmOptionsFileAssoc.Load;
var
  I : Integer;
  sName : String;
  Bitmap : TBitmap;
begin
  // load extension file
  if mbFileExists(gpCfgDir + 'doublecmd.ext') then
    Exts.LoadFromFile(gpCfgDir + 'doublecmd.ext');
  lbFileTypes.ItemHeight := Max(gIconsSize, lbFileTypes.Canvas.TextHeight('Pp')) + 4;
  // fill file types list box
  for I := 0 to Exts.Count - 1 do
    begin
      sName := Exts.Items[I].Name;
      if sName = '' then
        sName := Exts.Items[I].SectionName;

      // load icon for use in OnDrawItem procedure
      Bitmap := PixMapManager.LoadBitmapEnhanced(Exts.Items[I].Icon, gIconsSize, True, lbFileTypes.Color);
      lbFileTypes.Items.AddObject(sName, Bitmap);
    end;

  if Exts.Count > 0 then
    lbFileTypes.ItemIndex:= 0;

  UpdateEnabledButtons;

  inherited Load;
end;

function TfrmOptionsFileAssoc.Save: TOptionsEditorSaveFlags;
begin
  Exts.SaveToFile(gpCfgDir + 'doublecmd.ext');
  gExts.Clear;
  gExts.LoadFromFile(gpCfgDir + 'doublecmd.ext');
  Result:= inherited Save;
end;

class function TfrmOptionsFileAssoc.GetIconIndex: Integer;
begin
  Result := 34;
end;

class function TfrmOptionsFileAssoc.GetTitle: String;
begin
  Result:= rsOptionsEditorFileAssoc;
end;

procedure TfrmOptionsFileAssoc.UpdateEnabledButtons;
begin
  if (lbFileTypes.Items.Count = 0) or (lbFileTypes.ItemIndex = -1) then
    begin
      btnAddExt.Enabled:= False;
      btnAddAct.Enabled:= False;
      sbtnIcon.Enabled:= False;
      btnRemoveIcon.Enabled:= False;
    end
  else
    begin
      btnAddExt.Enabled:= True;
      btnAddAct.Enabled:= (lbExts.Items.Count > 0);
      sbtnIcon.Enabled:= btnAddAct.Enabled;
      btnRemoveIcon.Enabled:= btnAddAct.Enabled;
    end;

  if (lbExts.Items.Count = 0) or (lbExts.ItemIndex = -1) then
    btnRemoveExt.Enabled := False
  else
    btnRemoveExt.Enabled := True;

  if (lbActions.Items.Count = 0) or (lbActions.ItemIndex = -1) then
    begin
      btnRemoveAct.Enabled := False;
      btnUpAct.Enabled := False;
      btnDownAct.Enabled := False;
      edbAction.Enabled:= False;
      fneCommand.Enabled:= False;
      btnCommands.Enabled:= False;
      edbAction.Text:= '';
      fneCommand.FileName:= '';
    end
  else
    begin
      btnRemoveAct.Enabled := True;
      btnUpAct.Enabled := (lbActions.ItemIndex > 0);
      btnDownAct.Enabled := (lbActions.ItemIndex < lbActions.Items.Count - 1);
      edbAction.Enabled:= True;
      fneCommand.Enabled:= True;
      btnCommands.Enabled:= True;
    end;
end;

procedure TfrmOptionsFileAssoc.btnAddNewTypeClick(Sender: TObject);
var
  ExtAction : TExtAction;
  s: string;
begin
  s:= InputBox(Caption, rsMsgEnterName, '');
  if s='' then exit;
  ExtAction := TExtAction.Create;
  ExtAction.IconIndex:= -1;
  ExtAction.IsChanged := True;
  with lbFileTypes do
  begin
    ExtAction.Name := s;
    Items.AddObject(ExtAction.Name, nil);
    // add file type to TExts object
    Exts.AddItem(ExtAction);
    ItemIndex := Items.Count - 1;
  end;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnRemoveTypeClick(Sender: TObject);
var
  iIndex : Integer;
begin
  with lbFileTypes do
  begin
    iIndex := ItemIndex;
    if iIndex < 0 then Exit;
    FreeIcon(iIndex);
    Items.Delete(iIndex);
    Exts.DeleteItem(iIndex);
    if Items.Count = 0 then
    begin
      lbExts.Clear;
      lbActions.Clear;
    end
    else begin
      if iIndex = 0 then
        ItemIndex := 0
      else
        ItemIndex := iIndex - 1;
    end
  end;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnRemoveTypeResize(Sender: TObject);
begin
  SetMinimumSize;
end;

procedure TfrmOptionsFileAssoc.btnRenameTypeClick(Sender: TObject);
var
  iIndex : Integer;
  sName : String;
begin
  iIndex := lbFileTypes.ItemIndex;
  if iIndex < 0 then Exit;
  sName := lbFileTypes.Items[iIndex];
  sName := InputBox(Caption, rsMsgEnterName, sName);
  lbFileTypes.Items[iIndex] := sName;
  // rename file type in TExts object
  Exts.Items[iIndex].Name := sName;
  Exts.Items[iIndex].IsChanged:= True;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnRenameTypeResize(Sender: TObject);
begin
  SetMinimumSize;
end;

procedure TfrmOptionsFileAssoc.lbActionsSelectionChange(Sender: TObject; User: boolean);
var
  iIndex : Integer;
  slActions : TStringList;
begin
  iIndex := lbActions.ItemIndex;
  if (iIndex < 0) or (lbActions.Tag = 1) then Exit;
  slActions := TStringList(lbActions.Items.Objects[iIndex]);
  edbAction.Text := slActions.Names[iIndex];
  fneCommand.FileName := slActions.ValueFromIndex[iIndex];
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.lbExtsSelectionChange(Sender: TObject; User: boolean);
begin
  if (lbExts.ItemIndex < 0) then Exit;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.lbFileTypesDrawItem(Control: TWinControl;
  Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
  iDrawTop: Integer;
begin
  with (Control as TListBox) do
  begin
    if odSelected in State then
      begin
        Canvas.Font.Color := clHighlightText;
        Canvas.Brush.Color := clHighlight;
        Canvas.FillRect(ARect);
      end
    else
      begin
        Canvas.Font.Color := Font.Color;
        Canvas.Brush.Color := Color;
        Canvas.FillRect(ARect);
      end;

    if (Canvas.Locked = False) and (Assigned(Items.Objects[Index])) then
    begin
      iDrawTop := ARect.Top + ((lbFileTypes.ItemHeight - gIconsSize) div 2);
      Canvas.Draw(ARect.Left + 2, iDrawTop, TBitmap(Items.Objects[Index]));
    end;
    iDrawTop := ARect.Top + ((lbFileTypes.ItemHeight - Canvas.TextHeight(Items[Index])) div 2);
    Canvas.TextOut(ARect.Left + gIconsSize + 6, iDrawTop, Items[Index]);
  end;
end;

procedure TfrmOptionsFileAssoc.lbFileTypesSelectionChange(Sender: TObject;
  User: boolean);
var
  ExtCommand : TExtAction;
  I : Integer;
  bmpTemp: TBitmap = nil;
begin
  if (lbFileTypes.ItemIndex >= 0) and (lbFileTypes.ItemIndex < Exts.Count) then
    begin
      ExtCommand := Exts.Items[lbFileTypes.ItemIndex];
      lbExts.Items.Assign(ExtCommand.Extensions);
      if lbExts.Count > 0 then lbExts.ItemIndex := 0;
      lbActions.Items.Clear;
      for I := 0 to ExtCommand.Actions.Count - 1 do
      begin
        lbActions.Items.AddObject(ExtCommand.Actions.Names[I], ExtCommand.Actions);
      end;
      if lbActions.Count > 0 then lbActions.ItemIndex := 0;

      bmpTemp := PixMapManager.LoadBitmapEnhanced(ExtCommand.Icon, 32, True, sbtnIcon.Color);
      try
        sbtnIcon.Glyph := bmpTemp;
      finally
        if Assigned(bmpTemp) then
          FreeAndNil(bmpTemp);
      end;

      FUpdatingControls := True; // Don't trigger OnChange
      edtIconFileName.Text:= ExtCommand.Icon;
      FUpdatingControls := False;
    end
  else
    begin
      lbExts.Items.Clear;
      lbActions.Items.Clear;
      sbtnIcon.Glyph.Clear;
      edtIconFileName.Text := '';
    end;

  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.edtActionChange(Sender: TObject);
var
  iIndex : Integer;
  slActions : TStringList;
begin
  iIndex := lbActions.ItemIndex;
  if (iIndex < 0) or (edbAction.Text = '') then Exit;
  slActions := TStringList(lbActions.Items.Objects[iIndex]);
  slActions.Strings[iIndex] := edbAction.Text + '=' + slActions.ValueFromIndex[iIndex];
  lbActions.Items[iIndex] := edbAction.Text;
  if lbFileTypes.ItemIndex >= 0 then
    Exts.Items[lbFileTypes.ItemIndex].IsChanged:= True;
end;

procedure TfrmOptionsFileAssoc.fneCommandChange(Sender: TObject);
var
  iIndex : Integer;
  slActions : TStringList;
begin
  iIndex := lbActions.ItemIndex;
  if (iIndex < 0) or (fneCommand.Text = '') then Exit;
  slActions := TStringList(lbActions.Items.Objects[iIndex]);
  slActions.ValueFromIndex[iIndex] := fneCommand.Text;
  if lbFileTypes.ItemIndex >= 0 then
    Exts.Items[lbFileTypes.ItemIndex].IsChanged:= True;
end;

procedure TfrmOptionsFileAssoc.miActionsClick(Sender: TObject);
var
  miMenuItem: TMenuItem absolute Sender;
begin
  if miMenuItem.Name = 'miOpen' then
    edbAction.Text:= 'Open'
  else if miMenuItem.Name = 'miView' then
    edbAction.Text:= 'View'
  else if miMenuItem.Name = 'miEdit' then
    edbAction.Text:= 'Edit';
end;

procedure TfrmOptionsFileAssoc.miCommandsClick(Sender: TObject);
var
  miMenuItem: TMenuItem absolute Sender;
begin
  if miMenuItem.Name = 'miVfs' then
    fneCommand.Text:= fneCommand.Text + '{!VFS} '
  else if miMenuItem.Name = 'miViewer' then
    fneCommand.Text:= fneCommand.Text + '{!VIEWER} '
  else if miMenuItem.Name = 'miEditor' then
    fneCommand.Text:= fneCommand.Text + '{!EDITOR} '
  else if miMenuItem.Name = 'miShell' then
    fneCommand.Text:= fneCommand.Text + '{!SHELL} '
  else if miMenuItem.Name = 'miGetOutputFromCommand' then
    begin
      fneCommand.Text:= fneCommand.Text + '<??>';
      fneCommand.SetFocus;
      fneCommand.SelStart:= Pos('?>', fneCommand.Text) - 1;
    end
  else if miMenuItem.Name = 'miFileName' then
    fneCommand.Text:= fneCommand.Text + '%f'
  else if miMenuItem.Name = 'miFilePath' then
    fneCommand.Text:= fneCommand.Text + '%d'
  else if miMenuItem.Name = 'miFullPath' then
    fneCommand.Text:= fneCommand.Text + '%p';
end;

procedure TfrmOptionsFileAssoc.pnlRightSettingsResize(Sender: TObject);
begin
  gbExts.Height := pnlRightSettings.ClientHeight div 4;
end;

procedure TfrmOptionsFileAssoc.pnlSettingsResize(Sender: TObject);
begin
  pnlLeftSettings.Width := pnlSettings.ClientWidth div 3;
end;

procedure TfrmOptionsFileAssoc.sbtnIconClick(Sender: TObject);
begin
  OpenPictureDialog.FileName:= NormalizePathDelimiters(edtIconFileName.Text);
  if OpenPictureDialog.Execute then
    edtIconFileName.Text := OpenPictureDialog.FileName; // Triggers OnChange
end;

procedure TfrmOptionsFileAssoc.btnRemoveIconClick(Sender: TObject);
begin
  edtIconFileName.Text:= ''; // Triggers OnChange
end;

procedure TfrmOptionsFileAssoc.btnAddExtClick(Sender: TObject);
var
  sExt : String;
begin
  sExt := InputBox(Caption, rsMsgEnterFileExt, '');
  if sExt <> '' then
    begin
      lbExts.ItemIndex := lbExts.Items.Add(sExt);
      // add extension in TExts object
      Exts.Items[lbFileTypes.ItemIndex].Extensions.Add(sExt);
      Exts.Items[lbFileTypes.ItemIndex].IsChanged:= True;
    end;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnRemoveExtClick(Sender: TObject);
var
  I : Integer;
begin
  // remove extension from extensions listbox
  with lbExts do
  begin
    I := ItemIndex;
    if I < 0 then Exit;
    Items.Delete(I);
    if Items.Count > 0 then
    begin
      if I = 0 then
        ItemIndex := 0
      else
        ItemIndex := I - 1;
    end;
  end;
  // remove extension from TExts object
  Exts.Items[lbFileTypes.ItemIndex].Extensions.Delete(I);
  Exts.Items[lbFileTypes.ItemIndex].IsChanged:= True;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnUpActClick(Sender: TObject);
var
  I : Integer;
begin
  // move action in actions listbox
  with lbActions do
  begin
    Tag := 1; // start moving
    I := ItemIndex;
    if I = - 1 then exit;
    if I > 0 then
    begin
      Items.Move(I, I - 1);
      ItemIndex:= I - 1;
    end;
  end;
  // move action in TExts object
  with lbFileTypes do
  begin
    Exts.Items[ItemIndex].Actions.Move(I, I - 1);
    Exts.Items[ItemIndex].IsChanged:= True;
  end;
  lbActions.Tag := 0; // end moving
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.edtIconFileNameChange(Sender: TObject);
begin
  if not FUpdatingControls then
    SetIconFileName(edtIconFileName.Text);
end;

procedure TfrmOptionsFileAssoc.fneCommandAcceptFileName(Sender: TObject;
  var Value: String);
begin
  if Pos(#32, Value) = 0 then
    Value:= Value + #32
  else
    Value:= QuoteStr(Value) + #32;
end;

procedure TfrmOptionsFileAssoc.btnDownActClick(Sender: TObject);
var
  I : Integer;
begin
  // move action in actions listbox
  with lbActions do
  begin
    Tag := 1; // start moving
    I := ItemIndex;
    if I = - 1 then exit;
    if (I < Items.Count - 1) and (I > -1) then
    begin
      Items.Move(I, I + 1);
      ItemIndex:= I + 1;
    end;
  end;
  // move action in TExts object
  with lbFileTypes do
  begin
    Exts.Items[ItemIndex].Actions.Move(I, I + 1);
    Exts.Items[ItemIndex].IsChanged:= True;
  end;
  lbActions.Tag := 0; // end moving
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnAddActClick(Sender: TObject);
var
  I : Integer;
  ExtAction : TExtAction;
begin
  with lbFileTypes do
    ExtAction := Exts.Items[ItemIndex];
    ExtAction.IsChanged:= True;
  // add action to TExts object
  I := ExtAction.Actions.Add('=');
  // add action to actions listbox
  with lbActions do
  begin
    Items.AddObject('', ExtAction.Actions);
    ItemIndex := I;
  end;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnActionsClick(Sender: TObject);
begin
  pmActions.PopUp();
end;

procedure TfrmOptionsFileAssoc.btnRemoveActClick(Sender: TObject);
var
  I : Integer;
begin
  // remove action from actions listbox
  with lbActions do
  begin
    I := ItemIndex;
    if I < 0 then Exit;
    Items.Delete(I);
  end;
  // remove action from TExts object
  with lbFileTypes do
  begin
    Exts.Items[ItemIndex].Actions.Delete(I);
    Exts.Items[ItemIndex].IsChanged:= True;
  end;
  // update action index
  if lbActions.Count > 0 then
  begin
    if I = 0 then
      lbActions.ItemIndex := I
    else
      lbActions.ItemIndex := I - 1;
  end;
  UpdateEnabledButtons;
end;

procedure TfrmOptionsFileAssoc.btnCommandsClick(Sender: TObject);
begin
  pmCommands.PopUp();
end;

procedure TfrmOptionsFileAssoc.FreeIcon(iIndex: Integer);
begin
  with lbFileTypes do
  begin
    Canvas.Lock;
    try
      if Assigned(Items.Objects[iIndex]) then
      begin
        Items.Objects[iIndex].Free;
        Items.Objects[iIndex] := nil;
      end;
    finally
      Canvas.Unlock;
    end;
  end;
end;

procedure TfrmOptionsFileAssoc.SetIconFileName(const sFileName: String);
var
  bmpTemp: TBitmap;
  Index: Integer;
begin
  if sFileName <> EmptyStr then
    begin
      bmpTemp:= PixMapManager.LoadBitmapEnhanced(sFileName, 32, True, sbtnIcon.Color);
      if Assigned(bmpTemp) then
        begin
          sbtnIcon.Glyph.Assign(bmpTemp);
          FreeAndNil(bmpTemp);
        end
      else
        sbtnIcon.Glyph.Clear;
    end
  else
    sbtnIcon.Glyph.Clear;

  Index := lbFileTypes.ItemIndex;
  if (Index >= 0) and (Index < Exts.Count) then
  begin
    FreeIcon(Index);
    if sFileName <> EmptyStr then
      // save icon for use in OnDrawItem procedure
      lbFileTypes.Items.Objects[Index]:= PixMapManager.LoadBitmapEnhanced(sFileName, gIconsSize, True, Color);
    lbFileTypes.Repaint;

    Exts.Items[Index].Icon:= sFileName;
    Exts.Items[Index].IconIndex:= -1;
    Exts.Items[Index].IsChanged:= True;
  end;
end;

procedure TfrmOptionsFileAssoc.SetMinimumSize;
begin
  gbFileTypes.Constraints.MinWidth :=
    gbFileTypes.BorderSpacing.Left +
    btnRemoveType.Left +
    btnRemoveType.Width +
    5 + // space between
    btnRenameType.Width +
    gbFileTypes.Width - (btnRenameType.Left + btnRenameType.Width) +
    gbFileTypes.BorderSpacing.Right;

  pnlLeftSettings.Constraints.MinWidth :=
    gbFileTypes.Constraints.MinWidth +
    gbFileTypes.BorderSpacing.Around;

  Constraints.MinWidth :=
    pnlLeftSettings.Constraints.MinWidth +
    pnlLeftSettings.BorderSpacing.Left +
    pnlLeftSettings.BorderSpacing.Right +
    pnlLeftSettings.BorderSpacing.Around +
    pnlRightSettings.Constraints.MinWidth +
    pnlRightSettings.BorderSpacing.Left +
    pnlRightSettings.BorderSpacing.Right +
    pnlRightSettings.BorderSpacing.Around;
end;

end.

