function Get-MimecastDateTime{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object Windows.Forms.Form -Property @{
        StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
        Size          = [drawing.size]::new(225,275)
        Text          = 'Select a Date'
        Topmost       = $true
    }

    $calendar = New-Object Windows.Forms.MonthCalendar -Property @{
        Location = [drawing.size]::new(15,15)
        ShowTodayCircle   = $false
        MaxSelectionCount = 1
    }
    $form.Controls.Add($calendar)

    $TimePicker = New-Object System.Windows.Forms.DateTimePicker
    $TimePicker.Size = [Drawing.Size]::new(125,25)
    $TimePicker.Location = [Drawing.Size]::new(40,175)
    $TimePicker.ShowUpDown = $true
    $TimePicker.Format = [System.Windows.Forms.DateTimePickerFormat]::Time
    $form.Controls.Add($TimePicker)

    $okButton = New-Object Windows.Forms.Button -Property @{
        Location     = [drawing.size]::new(30,200)
        Size         = [drawing.size]::new(75,23)
        Text         = 'OK'
        DialogResult = [Windows.Forms.DialogResult]::OK
    }
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button -Property @{
        Location     = [drawing.size]::new(105,200)
        Size         = New-Object Drawing.Size 75, 23
        Text         = 'Cancel'
        DialogResult = [Windows.Forms.DialogResult]::Cancel
    }
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $result = $form.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        $date = $calendar.SelectionStart
        $time = $TimePicker.Value
        $SelectionDate = ([DateTime]::new($date.Year,$date.Month,$date.Day,$time.Hour,$time.Minute,0)).ToUniversalTime()
        $SelectionDate.ToString("yyyy-MM-ddTHH:mm:ss+0000")
    }
}