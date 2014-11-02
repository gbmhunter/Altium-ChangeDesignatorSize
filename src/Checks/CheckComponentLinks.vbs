Sub CheckComponentLinks(dummyVar)

    Dim workspace           'As IWorkspace
    Dim pcbProject          'As IProject
    Dim document            'As IDocument
    Dim pcbBoard            'As IPCB_Board
    Dim pcbObject           'As IPCB_Primitive;
    Dim docNum              'As Integer

    StdOut("Checking component links...")

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        StdOut(" Component links check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    IF pcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
        StdOut(" Component links check complete." + vbCr + vbLf)      
        Exit Sub
    End If

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Set document = pcbProject.DM_LogicalDocuments(docNum)
        ' ShowMessage(document.DM_DocumentKind)
        ' If this is PCB document
        If document.DM_DocumentKind = "PCB" Then
            ' ShowMessage('PCB Found');
            Set pcbBoard = PCBServer.GetPCBBoardByPath(document.DM_FullPath)
            Exit For
        End If
    Next

    If pcbBoard Is Nothing Then
        StdErr("ERROR: No PCB document found. Path used = " + document.DM_FullPath + "." + vbCr + vbLf)
        StdOut(" Component links check complete." + vbCr + vbLf)
        Exit Sub
    End If

    document.DM_LoadDocument()

    ' Check for component links
    ResetParameters
    Call AddStringParameter("ObjectKind", "Project")
    Call AddStringParameter("Action", "ComponentLinking")
    Call RunProcess("WorkspaceManager:DocumentOptions")

    ' Output
    StdOut(" Component links check complete." + vbCr + vbLf)

End Sub


