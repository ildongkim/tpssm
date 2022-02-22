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
	
	//성공, 실패와 관계 없이 응답을 받았을 경우 실행
	grid.on('response', function(ev) {
		//console.log('성공, 실패와 관계 없이 응답을 받았을 경우 실행');
	});
	
	grid.on('beforeRequest', function(ev) {
		//console.log('요청을 보내기 전 실행');
	});
			
	grid.on('successResponse', function(ev) {
		//console.log('결과가 true인 경우');
	});
	
	grid.on('failResponse', function(ev) {
		try {
			var responseObj = JSON.parse(ev.xhr.response);
			if (responseObj.message) { confirm(responseObj.message); }
		} catch (error) {
			confirm("요청처리를 실패하였습니다.");
		}
	});
	
	grid.on('errorResponse', function(ev) {
		confirm("요청처리를 실패하였습니다.");
	});
}

/*********************************************************
 * TUI.GRID datasource
 ******************************************************** */
function setReadData(url) {
	var datasource = {
		contentType: 'application/x-www-form-urlencoded',
		api: { 
			readData: { url: url, method: 'POST' }
		},
		hideLoadingBar: true,
		initialRequest: false 
	};
	return datasource;
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

/*********************************************************
* Program File Name Search Modal
******************************************************** */
function isNullToString(obj) {
	return (obj == null) ? "" : obj;
}

/*********************************************************
* Hierarchy MenuList delete empty folder
******************************************************** */
function getHierarchyMenuList(array) {
	//console.log('HierarchyMenuList');
	array.forEach(function(data, idx) {
		if (data['_children'].length > 0) {
			getHierarchyMenuList(data['_children']);
		} else {
			delete data['_children'];			
		}
	});
}

/* ********************************************************
 * Grid Checkbox Renderer
 ******************************************************** */
class CustomCheckBox {
	constructor(props) {
		const el = document.createElement('input');
		const { grid, rowKey, columnInfo } = props;
		el.type = 'checkbox';
		el.checked = props.value == "Y" ? true : false;
		el.onchange = function (e) { grid.setValue(rowKey, columnInfo.name, this.checked ? "Y" : "N"); };
		this.el = el;
	}
	
	getElement() {
        return this.el;
    }
}

/* ********************************************************
 * Grid Selected Row Find Sample
 ******************************************************** */
//function setSendData(jarr) {
//	for(idx in jarr) {
//		jarr[idx].uniqId = grid.getRow(grid.getFocusedCell()['rowKey'])['uniqId'];
//	}
//	return jarr;
//}