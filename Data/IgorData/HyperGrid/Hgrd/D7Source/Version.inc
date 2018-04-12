const MajorVersion = 2; MinorVersion = 23;
{
	HISTORY
	==================================
	ver 2.10
	==================================
		checkboxes (3 kinds, as CheckBox, as RadioButton, As User Defined text
		format Upper,Lower, 1st Letter Up

	ver 2.11
	==================================
		corrections
			for checkboxes exporting to Excell
			for checkboxes Saving and Loading to File
			on numeric format to not permit the key thousandseparator
		Additions
			- SaveColsToFile( StartCol , EndCol, StartRow : Longint; const FileName : string );
			- LoadColsFromFile( StartCol , EndCol, StartRow : Longint; const FileName : string );
			- SaveColsToStream( StartCol ,EndCol, StartRow : Longint; Stream : TStream );
			- LoadColsFromStream( StartCol, EndCol, StartRow : Longint; Stream : TStream );

	ver 2.20
	==================================
		corrections
			for checkboxes to draw the selection over them
			for numeric and scientific not exception on wrong format
				by using texttofloat instead of strtofloat

		Additions
			The posibillity for extended selection
			with mouse and contrl - for selecting in row basis
			used with
				- Added property Selected[RowNumber], do not use the Selection property anymore!
				- Added property SelectedCount
				- Added property SelectedItems[1 to SelectedCount];
				- Added function ClearSelection
			!!!
			when you are change from not edit mode to edit mode
			you must call the ClearSelection procedure to clear
			all selected items
	ver 2.21
	==================================
		Additions
		- Added procedure TransformRow(FromRow, ToRow: Integer);
		Modifications
		- If it is ComboBox and dropDown the it drops Aytomatically
			with selected the allready given text (if any) or dependending on
			the key selectes (if any) the first item strarting with this letter

	ver 2.22  //RVS03
	==================================
		additions
		- hgoptSpecialSelection of ThgOption
			to maintain the Special Selection by using the Control key
		- the posibility to save by the Column Titles by
			the SaveColsToFile when you start from row 0

	ver 2.23  //RVS04
	==================================
		additions
		- hgoptSkipReadOnly of ThgOption
			if in edit mode and a column is readonly then
			skip to next edit column
		- hgoptCycleTravel of ThgOption
			the next,prev keys travels cycling the grid
}

