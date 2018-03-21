var status = 1;
var Menus = new DvMenuCls;

document.onclick=Menus.Clear;
function switchSysBar(){
	var switchPoint=document.getElementById("switchPoint");
	var frmTitle=document.getElementById("frmTitle");
     if (1 == window.status){
		  window.status = 0;
		  //alert(switchPoint);

          switchPoint.style.backgroundImage = 'url(images/common/left.gif)';
          frmTitle.style.display="none"
     }
     else{
		  window.status = 1;
          switchPoint.style.backgroundImage = 'url(images/common/right.gif)'; 
          frmTitle.style.display=""
     }
}

function DvMenuCls(){
	var MenuHides = new Array();
	this.Show = function(obj,depth){
		var childNode = this.GetChildNode(obj);
		if (!childNode){return ;}
		if (typeof(MenuHides[depth])=="object"){
			this.closediv(MenuHides[depth]);
			MenuHides[depth] = '';
		};
		if (depth>0){
			if (childNode.parentNode.offsetWidth>0){
				childNode.style.left= childNode.parentNode.offsetWidth+'px';
				
			}else{
				childNode.style.left='100px';
			};
			
			childNode.style.top = '-2px';
		};

		childNode.style.display ='none';
		MenuHides[depth]=childNode;
	
	};
	this.closediv = function(obj){
		if (typeof(obj)=="object"){
			if (obj.style.display!='none'){
			obj.style.display='none';
			}
		}
	}
	this.Hide = function(depth){
		var i=0;
		if (depth>0){
			i = depth
		};
		while(MenuHides[i]!=null && MenuHides[i]!=''){
			this.closediv(MenuHides[i]);
			MenuHides[i]='';
			i++;
		};
	
	};
	this.Clear = function(){
		for(var i=0;i<MenuHides.length;i++){
			if (MenuHides[i]!=null && MenuHides[i]!=''){
				MenuHides[i].style.display='none';
				MenuHides[i]='';
			}
		}
	}
	this.GetChildNode = function(submenu){
		for(var i=0;i<submenu.childNodes.length;i++)
		{
			if(submenu.childNodes[i].nodeName.toLowerCase()=="div")
			{
				var obj=submenu.childNodes[i];
				break;
			}
		}
		return obj;
	}

}


function getleftbar(obj){
	var leftobj;
	var titleobj=obj.getElementsByTagName("a");
	leftobj = document.all ? frames["frmleft"] : document.getElementById("frmleft").contentWindow;
	if (!leftobj){return;}
	var menubar = leftobj.document.getElementById("menubar")
	if (menubar){
			if (titleobj[0]){
				document.getElementById("leftmenu_title").innerHTML = titleobj[0].innerHTML;
			}
			var a=obj.getElementsByTagName("ul");
			for(var i=0;i<a.length;i++){
				menubar.innerHTML = a[i].innerHTML;
				//alert(a[i].innerHTML);
			}
	}
}
