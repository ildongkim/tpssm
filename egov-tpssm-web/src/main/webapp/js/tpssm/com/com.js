/*********************************************************
 * TUI.GRID Theme
 ******************************************************** */
tui.Grid.applyTheme('default', {
	selection: {
        background: "#00A9ff",
        border: '#00a9ff'
    },
	cell: {
		normal: {
            background: "#F5F5F5",
            border: "#D0D0D0",
            text: "#222",
            showVerticalBorder: !0,
            showHorizontalBorder: !0
        },
		header: {
            background: "#EDEDED",
            border: "#D0D0D0",
            text: "#222",
            showVerticalBorder: !0,
            showHorizontalBorder: !0
        },
        rowHeader: {
            background: "#EDEDED",
            border: "#D0D0D0",
            showVerticalBorder: !0,
            showHorizontalBorder: !0
        },
        selectedHeader: {
            background: "#EDEDED",
            border: "#D0D0D0"
        },
        selectedRowHeader: {
            background: "none"
        },
        focused: {
            border: "none"
        },
        focusedInactive: {
            border: "none"
        }, 
        currentRow: {
        	background: "#FAE8DF"
        }
	},
    row: {
    	hover: {
        	background: "#FAE8DF"
    	},
    	odd : {
    		background: "#ffffff"
    	},
    	even : {
    		background: "#F5F5F5"
    	}
    }
});

/*********************************************************
 * TUI.GRID Event
 ******************************************************** */
function setGridEvent(grid) {
	var selectedRowKey = null;
	grid.on('focusChange', function (ev) {
		if (selectedRowKey != null) {
			grid.removeRowClassName(selectedRowKey, 'currentRow');
		}
		selectedRowKey = ev.rowKey;
		grid.addRowClassName(selectedRowKey, 'currentRow');
	});
	
	grid.on('dblclick', function (ev) {
		return;
	});
}

/*********************************************************
* Program File Name Search Modal
******************************************************** */
function settingDialog(options) {
	$dialog = $('<div></div>')
	.html('<iframe style="border: 0px; " src="' + options['pageUrl'] + '" width="100%" height="100%"></iframe>')
	.dialog({autoOpen: false, modal: true, width: options['width'], height: options['height'], title: options['pagetitle']});
	$dialog.dialog('open');
	$('.ui-dialog').css('z-index', '120');
} 