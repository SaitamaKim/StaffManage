var persons;
$('#open-excel').change(function(e) {
    var files = e.target.files;

    var fileReader = new FileReader();
    fileReader.onload = function(ev) {
        try {
            var data = ev.target.result,
                workbook = XLSX.read(data, {
                    type: 'binary'
                }), // 以二进制流方式读取得到整份excel表格对象
                persons = []; // 存储获取到的数据
        } catch (e) {
            console.log('文件类型不正确');
            return;
        }

        // 表格的表格范围，可用于判断表头数量是否正确
        var fromTo = '';
        // 遍历每张表读取
        for (var sheet in workbook.Sheets) {
            if (workbook.Sheets.hasOwnProperty(sheet)) {
                fromTo = workbook.Sheets[sheet]['!ref'];
                console.log(fromTo);//打印表格范围
                persons =persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
                /*使用XLSX.utils.sheet_to_json方法解析表格对象返回相应的JSON数据 */

                break; // 如果不只取第一张表，就注释这行
            }
        }

        //console.log(persons);//打印获取的数据
        /**
         * 把获取的json绑定到表格中
         */
        if(persons.length===0) {
            alert("文件空！");
        }else{
            persons.forEach(function (row) {
                var tr = document.createElement("tr");
                for(var key in row){
                    var td = document.createElement("td");
                    td.innerHTML = row[key];
                    tr.appendChild(td);
                }
                var delTd = document.createElement('td');
                delTd.className = 'del-col';
                var delA = document.createElement('a');
                delA.href = 'javascript:void(0);';
                delA.className = 'delBtn';
                delA.innerHTML = '删除';
                delTd.appendChild(delA);
                tr.appendChild(delTd);

                $('.append-row').before(tr);
                //绑定一下事件
                trEdit();
                delTr();


            })
        }

    };
    // 以二进制方式打开文件
    fileReader.readAsBinaryString(files[0]);

});



