function load_gd_penetrion_analysis(dist, sub, scenario, circ, tipo_dia, mes, ano, type_case, txt_title) {
    document.body.style.cursor = 'progress';  // Cursor de espera
    //console.log(type_case)
    fetch(`/z_data?distribuidora=${dist}&subestacao=${sub}&scenario=${scenario}&circuito=${circ}&tipo_dia=${tipo_dia}&mes=${mes}&ano=${ano}&type_case=${type_case}`)  // Atenção ao tipo de aspas - backticks
        .then(response => {
            if (!response.ok){
                alert("No Data Found!")
                throw new Error ("No Data Found!")
            }
            return response.json();
        })
        .then(data => {
            console.log(data)
            if (data.error) {
                //console.error(data.error);
                return;
            }
            var surf_data = [];
            var layout = {};
            var columnId = 7;           // coluna de dados para o fluxo reverso
            var columnMediumId = 2;     // coluna de dados das Mediana das perdas
            var txtTitleplot = 'Reverse Power Flow';
            var xmax = 0;               // linha horizontal
            var y_set = 0;              // linha horizontal
            //txtsubtitle = ['FP: 0.8 ind.', 'FP: 0.8 cap.', 'FP: 0.9 ind.', 'FP: 0.9 cap.', 'FP: 1.0', '']
            txtsubtitle = ['FP: 0.9 ind.', 'FP: 0.9 cap.', 'FP: 0.95 ind.', 'FP: 0.95 cap.', 'FP: 1.0', '']
            colorLine = ['red', 'blue', 'green', 'DeepPink', 'black'];
            if (type_case == 'PF_Losses') {
                columnId = 6;           // coluna de dados das perdas
                columnMediumId = 1      // coluna de dados para as medinas do fluxo reverso
                txtTitleplot = 'Energy Losses Analysis';
            }
            if (type_case == 'BESS_Losses')  {
                txtsubtitle = ['PV/BESS: 0.5 ', 'PV/BESS: 0.6', 'PV/BESS: 0.7', 'PV/BESS: 0.9', '', '']
                columnId = 6;           // coluna de dados para as perdas
                columnMediumId = 1      // coluna de dados para as medinas do fluxo reverso
                txtTitleplot = 'Energy Losses Analysis';

            } else if (type_case == 'BESS_RPF') {
                txtsubtitle = ['PV/BESS: 0.5 ', 'PV/BESS: 0.6', 'PV/BESS: 0.7', 'PV/BESS: 0.9', '', '']
                columnId = 7;           // coluna de dados para o fluxo reverso
                columnMediumId = 2;     // coluna de dados das Mediana das perdas
                txtTitleplot = 'Reverse Power Flow';
            }

            destroy_charts(4);
            removeCanvas(4);
            switch (type_case) {
                case 'BESS_Losses':
                case 'BESS_RPF':
                case 'PF_Losses':
                case 'PF_RPF':

                    let max_data = data.length-1;
                    data.forEach((item, index) => {
                        if (index == max_data) {
                            //console.log(item);
                            const medium_penetration = item[0].slice(0).map(row => row[0]);
                            x_max = Math.max(...medium_penetration);
                            //console.log(medium_penetration);
                            let medium_ener_losses = new Array(); // Creates an empty array
                            let mediumtrace = new Array();
                            for (let i = 0; i <= item.length-1; i++) {
                                medium_ener_losses[i] = item[i].slice(0).map(row => row[columnMediumId]);
                                //const medium_ener_losses2 = item[1].slice(0).map(row => row[columnMediumId]);
                                //const medium_ener_losses3 = item[2].slice(0).map(row => row[columnMediumId]);
                                //const medium_ener_losses4 = item[3].slice(0).map(row => row[columnMediumId]);
                                //const medium_ener_losses5 = item[4].slice(0).map(row => row[columnMediumId]);
                                mediumtrace[i] = {
                                    type: 'scatter',
                                    mode: "lines",
                                    line: {color: colorLine[i]},  //line: {color: 'red', width: 1, shape: 'spline'},
                                    x: medium_penetration,
                                    y: medium_ener_losses[i],
                                    name: txtsubtitle[i],
                                };
                            }
                            var all_mediumData = [];
                            for (let i = 0; i <= item.length-1; i++) {
                                all_mediumData.push(mediumtrace[i])
                            }
                            surf_data.push(all_mediumData);

                        } else {
                            const penetration = item.slice(0).map(row => row[0]);
                            x_max = Math.max(...penetration);
                            const ener_losses = item.slice(0).map(row => row[columnId]); //  coluna (exceto o cabeçalho)
                            console.log(penetration);
                            console.log(ener_losses);
                            var data = [{
                                type: 'box',
                                x: penetration,
                                y: ener_losses,
                                boxmean: true,     // Show mean line  ( true | "sd" | false )
                                boxpoints: false,  //( "all" | "outliers" | "suspectedoutliers" | false )
                            }];
                            surf_data.push(data);
                        }
                    });

                    //console.log(surf_data);
                    layout = {
                        title: {
                            text: txtTitleplot,
                            font: { size: 14, color: 'black' }
                        },
                        yaxis: {
                            title: {
                                text: 'Energy Losses (kWh)',
                                font: { size: 11, color: 'black' }
                            },
                            zeroline: false,
                            nticks: 4,
                        },
                        xaxis: {
                            title: {
                                text: 'Penetration (%)',
                                font: { size: 11, color: 'black' }
                            },
                            nticks: 11,
                            tickfont: {
                                size: 10 // Set the font size for x-axis tick labels
                            },
                        },
                        shapes: [
                            {
                              type: 'line',     // threshold line
                              x0: 0, // Starting x-coordinate of the line (relative to the plot area)
                              y0: y_set, // Starting y-coordinate of the line (data value)
                              x1: x_max, // Ending x-coordinate of the line (relative to the plot area, 1 means full width)
                              y1: y_set, // Ending y-coordinate of the line (data value)
                              line: {
                                color: 'red',
                                width: 2,
                                dash: 'dot' // Optional: 'solid', 'dot', 'dash', 'longdash', 'dashdot', 'longdashdot'
                              }
                            }],
                    };
                    break;

                default:
                    const x = data[0].slice(1); // Primeira linha (exceto o primeiro valor) = eixo X
                    const y = data.slice(1).map(row => row[0]); // Primeira coluna (exceto o cabeçalho) = eixo Y
                    const z = data.slice(1).map(row => row.slice(1)); // Valores Z

                    // filtro dos dados para gerar a curva de probabilidade
                    const xValues = data.slice(1).map(row => row[0]);
                    columnIndex = 50;
                    const yValues = data.slice(1).map(row => row[columnIndex]);
                    console.log (xValues);
                    console.log (yValues);

                    data = [{
                        type: 'surface',
                        x: x,
                        y: y,
                        z: z,
                        colorscale: 'Viridis',
                        contours: {
                            z: {
                              show:true,
                              usecolormap: true,
                              highlightcolor:"#42f462",
                              project:{z: true}
                            }
                          }
                    }];
                    surf_data.push(data);
                    layout = {
                        title: {
                            text: 'DER´s Insertion Analysis: ' + sub +': '+ circ +' '+ tipo_dia +' '+ano +'/'+ mes + '<br>' + txt_title,
                            font: { size: 14, color: 'black' }
                        },
                        scene: {
                            xaxis: { title: { text: 'PV Penetration %' } },
                            yaxis: { title: { text: 'Buses %' } },
                            zaxis: { title: { text: 'Probability %' } }
                        },
                        autosize: true,
                        width: 450,
                        height: 350,
                        margin: {
                            l: 0,
                            r: 10,
                            b: 5,
                            t: 30,
                        }
                    };
                    break;
            };

            removedivChart(6);
            const chartContainer = document.getElementById(`chart-container`);
            for (let i = 1; i <= 6; i++) {
                const graphDiv = document.createElement('div');
                graphDiv.id = `chart${i}`;
                graphDiv.style.width = '58vh';
                graphDiv.style.height = '20vw';
                graphDiv.style.display = 'inline-block';
                chartContainer.appendChild(graphDiv);
            }
            console.log(surf_data.length)
            var config = {
                responsive: true,
                scrollZoom: true
            };
            for (let i = 1; i <= surf_data.length; i++) {
                const chart = document.getElementById(`chart${i}`);
                chart.style.height = '20vw';
                if (surf_data.length > 1) {
                    var layout2 = JSON.parse(JSON.stringify(layout));  // clone para evitar conflito
                    layout2.title.text = txtTitleplot + '-' + circ + '<br>' + txtsubtitle[i-1] ;
                    if (type_case == 'PF_Losses' || type_case == 'BESS_Losses'){
                        //console.log('Teste valores inicial:');
                        layout2.shapes[0].y0 = surf_data[i-1][0].y[0];
                        layout2.shapes[0].y1 = surf_data[i-1][0].y[0]
                    }
                } else {
                    layout2 = layout;
                }
                Plotly.newPlot(chart, surf_data[i-1], layout2, config);
            }
            // implementa o eventListener para selecionar o DIv e aumentar o gráfico
            createEventChart();

        })
}

function daily_load(dist, sub, circ, scenario, tipo_dia,  ano, mes ) {
    document.body.style.cursor = 'progress';  // Cursor de espera
    console.log(ano)
    fetch(`/daily_power_circuit?distribuidora=${dist}&subestacao=${sub}&circuito=${circ}&scenario=${scenario}&tipo_dia=${tipo_dia}&ano=${ano}&mes=${mes}`)  // Atenção ao tipo de aspas - backticks
        .then(response => {
            if (!response.ok){
                alert("No Data Found!")
                throw new Error ("No Data Found!")
            }
            return response.json();
        })
        .then(data => {
            console.log(data)
            // verifica se existe e cria os elementos necessaris para colocar os graficos
            createCanvas(4);
            removedivChart(6);
            const ctx1 = document.getElementById('myChart1').getContext('2d', { willReadFrequently: true });
            const ctx2 = document.getElementById('myChart2').getContext('2d', { willReadFrequently: true });
            var str_dist = document.getElementById('distribuidora').options[document.getElementById('distribuidora').selectedIndex].text;
            //console.log(data[0].values)
            //console.log(data[4].values)
            //console.log(data[0].ctmt)
            //console.log(data[1])
            //console.log(data[4])
            //console.log(Object.entries(data).length)

            // verificar se exitem muitas legendas no grafico e desabilitar caso for maior que um valor máximo
            const num_lines = Object.entries(data).length;
            const max_legend = 20;


            // limpa para poder reutilizar.
            destroy_charts(4);

            var myChart1 = new Chart(ctx1, {
                type: 'line',
                data: {
                    datasets: [],
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Time of the Day',
                                font: {
                                    padding: 4,
                                    size: 14,
                                    weight: 'bold',
                                    family: 'Arial'
                                },
                                color: 'darkblue'
                                }
                        },
                        y: {
                            title: {
                                display: true,
                                text: 'Power (kW)',
                                font: {
                                    padding: 4,
                                    size: 14,
                                    weight: 'bold',
                                    family: 'Arial'
                                },
                                color: 'darkblue'
                            },
                            beginAtZero: true,
                            type: 'linear',

                        }
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },

                        title: {
                            display: true,
                            text: `${str_dist} - Circuit Daily Loading`
                        },
                        subtitle: {
                            display: true,
                        }
                    }
                }
            });


            var myChart2 = new Chart(ctx2, {
                type: 'line',
                data: {
                    datasets: [],
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Time of the Day',
                                font: {
                                    padding: 4,
                                    size: 14,
                                    weight: 'bold',
                                    family: 'Arial'
                                },
                                color: 'darkblue'
                                }
                        },
                        y: {
                            title: {
                                display: true,
                                text: 'Power (kW)',
                                font: {
                                    padding: 4,
                                    size: 14,
                                    weight: 'bold',
                                    family: 'Arial'
                                },
                                color: 'darkblue'
                            },
                            beginAtZero: true,
                            type: 'linear',

                        }
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },

                        title: {
                            display: true,
                            text: `${str_dist} - Circuit Daily Loading`
                        },
                        subtitle: {
                            display: true,
                        }
                    }
                }
            });

            myChart1.data.labels = data[0].time;
            myChart2.data.labels = data[0].time;

            for (i = 0; i < Object.entries(data).length; i++) {
                //if (i <  Object.entries(data).length/2) {
                if (data[i].tipo_dia == 'DU'){
                    myChart1.data.datasets.push({
                        data: data[i].values,
                        label: data[i].ctmt,
                    })
                } else if (data[i].tipo_dia == 'DO'){
                    myChart2.data.datasets.push({
                        data: data[i].values,
                        label: data[i].ctmt,
                    })
                }
            }
            //myChart1.data.datasets[0].data = data[0];
            //myChart1.data.datasets[1].data = data[4];

            myChart1.options.plugins.legend.align = 'end';
            myChart1.options.plugins.subtitle.text = 'Workdays - ' + ano + '- ' + mes;
            if (num_lines > max_legend) {
                myChart1.options.plugins.legend.display = false
                //myChart1.defaults.global.legend.display = false
            }
            myChart1.update();
            myChart2.options.plugins.legend.align = 'end';
            myChart2.options.plugins.subtitle.text = 'Sundays - '+ ano + ' - ' + mes;
            if (num_lines > max_legend) {
                myChart2.options.plugins.legend.display = false
                //myChart2.defaults.global.legend.display = false
            }
            myChart2.update();

        })
        .catch(error => console.log('Error loading chart data:', error));
    document.body.style.cursor = 'default';  // Cursor normal
}

function transformer_loading(dist, ano, mes) {
    // Captura o valor do parâmetro 'dist' da URL
    //const dist = "{{ dist }}";
    document.body.style.cursor = 'wait';  // Cursor de espera
    fetch(`/data?distribuidora=${dist}&ano=${ano}&mes=${mes}`)  // Atenção ao tipo de aspas - backticks
        .then(response => {
            //console.log(response);
            if (!response.ok){
                alert("No Data Found!")
                throw new Error ("No Data Found!")
            }
            return response.json();
        })
        .then(data => {
            var groupLabel1 = []
            var groupLabel2 = []
            var str_dist = document.getElementById('distribuidora').options[document.getElementById('distribuidora').selectedIndex].text;
            for (const [key, val] of Object.entries(data[1])) {
                groupLabel2.push(val)
            }
            for (const [key] of Object.entries(data[0])) {
                groupLabel1.push(key)
            }
            //console.log(groupLabel1)
            //console.log(groupLabel2)
            // verifica se existe e cria os elementos necessaris para colocar os graficos
            createCanvas(4);
            removedivChart(6);
            const ctx1 = document.getElementById('myChart1').getContext('2d', { willReadFrequently: true });
            const ctx2 = document.getElementById('myChart2').getContext('2d', { willReadFrequently: true });
            const ctx3 = document.getElementById('myChart3').getContext('2d', { willReadFrequently: true });
            const ctx4 = document.getElementById('myChart4').getContext('2d', { willReadFrequently: true });

            destroy_charts(4);

            var myChart1 = new Chart(ctx1, {
                type: 'bar',
                data: {
                    datasets: [
                        {
                            label: 'Max Power (p.u.)',
                            data: data[2],
                            backgroundColor: 'rgba(75,137,192, 0.2)',
                            borderColor: 'rgb(75,137,192)',
                            borderWidth: 1,
                        },
                        {
                            label: 'Min Power (p.u.)',
                            data: data[3],
                            backgroundColor: 'rgba(192,92,184, 0.2)',
                            borderColor: 'rgb(192,92,184)',
                            borderWidth: 1
                        },
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            labels: groupLabel1,
                        },
                        x2: {
                            labels: groupLabel2,
                        },
                        y: {
                            beginAtZero: true,
                            type: 'linear',
                            min: 0,
                            max: 1.2
                        }
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },

                        title: {
                            display: true,
                            text: `${str_dist} - Power Transformer Loading`
                        },
                        subtitle: {
                            display: true,
                            text: 'DO - 2022 - 12'
                        }
                    },
                    responsive: true,
                }
            });
            myChart1.options.plugins.legend.align = 'end';
            myChart1.update();

            var myChart2 = new Chart(ctx2, {
                type: 'bar',
                data: {
                    datasets: [
                        {
                            label: 'Max Power (p.u.)',
                            data: data[8],
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                        },
                        {
                            label: 'Min Power (p.u.)',
                            data: data[9],
                            backgroundColor: 'rgba(175, 92, 192, 0.2)',
                            borderColor: 'rgba(175, 92, 192, 1)',
                            borderWidth: 1
                        },
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            labels: groupLabel1,
                        },
                        y: {
                            beginAtZero: true
                        },
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },
                        title: {
                            display: true,
                            text: `${str_dist} - Power Transformer Loading`
                        },
                        subtitle: {
                            display: true,
                            text: 'DU - 2022 - 12'
                        },
                    }
                }
            });
            myChart2.options.plugins.legend.align = 'end';
            myChart2.update();


            var myChart3 = new Chart(ctx3, {
                type: 'bar',
                data: {
                    datasets: [
                        {
                            label: 'Time-Max-Power',
                            data: data[4],
                            backgroundColor: 'rgba(46,69,142, 0.2)',
                            borderColor: 'rgb(46,69,142)',
                            borderWidth: 1,
                        },
                        {
                            label: 'Time-Min-Power',
                            data: data[5],
                            backgroundColor: 'rgba(100,136,23, 0.2)',
                            borderColor: 'rgb(100,136,23)',
                            borderWidth: 1
                        },
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            labels: groupLabel1,
                        },
                        y: {
                            beginAtZero: true,
                            type: 'linear',
                            min: 0,
                            max: 24
                        },
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },
                        title: {
                            display: true,
                            text: `${str_dist} - Power Transformer Loading - Time of Day of Occurrence`
                        },
                        subtitle: {
                            display: true,
                            text: 'DO - 2022 - 12'
                        },
                    }
                }
            });
            myChart3.options.plugins.legend.align = 'end';
            myChart3.update();


            var myChart4 = new Chart(ctx4, {
                type: 'bar',
                data: {
                    datasets: [
                        {
                            label: 'Time-Max-Power',
                            data: data[10],
                            backgroundColor: 'rgba(46,69,142, 0.2)',
                            borderColor: 'rgb(46,69,142)',
                            borderWidth: 1,
                        },
                        {
                            label: 'Time-Min-Power',
                            data: data[11],
                            backgroundColor: 'rgba(100,136,23, 0.2)',
                            borderColor: 'rgb(100,136,23)',
                            borderWidth: 1
                        },
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    aspectRatio: 2,
                    scales: {
                        x: {
                            labels: groupLabel1,
                        },
                        y: {
                            beginAtZero: true,
                            type: 'linear',
                            min: 0,
                            max: 24
                        },
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },
                        title: {
                            display: true,
                            text: `${str_dist} - Power Transformer Loading - Time of Day of Occurrence`
                        },
                        subtitle: {
                            display: true,
                            text: 'DU - 2022 - 12'
                        },
                    }
                }
            });
            myChart4.options.plugins.legend.align = 'end';
            myChart4.update();
        })
        .catch(error => console.error('Error loading chart data:', error));
    document.body.style.cursor = 'default';  // Cursor normal
}

function losses(dist, subestacao, circuito, scenario, tipo_dia, ano, mes) {
    fetch(`/data_losses?distribuidora=${dist}&subestacao=${subestacao}&circuito=${circuito}&scenario=${scenario}&tipo_dia=${tipo_dia}&ano=${ano}&mes=${mes}`)
        .then(response => {
            if (!response.ok){
                alert("No Data Found!")
                throw new Error ("No Data Found!")
            }
            return response.json();
        })
        .then(data => {
            var groupLabel1 = []
            var groupLabel2 = []
            var str_dist = document.getElementById('distribuidora').options[document.getElementById('distribuidora').selectedIndex].text;
            for (const [key, val] of Object.entries(data[2])) {
                groupLabel2.push(val)
            }
            for (const [key] of Object.entries(data[1])) {
                groupLabel1.push(key)
            }
            //console.log(groupLabel1)
            //console.log(groupLabel2)
            // verifica se existe e cria os elementos necessaris para colocar os graficos
            createCanvas(4);
            removedivChart(6);
            const ctx1 = document.getElementById('myChart1').getContext('2d', { willReadFrequently: true });
            const ctx2 = document.getElementById('myChart2').getContext('2d', { willReadFrequently: true });

            destroy_charts(4);

            const myChart1 = new Chart(ctx1, {
                type: 'bar',
                data: {
                    datasets: [
                        {
                            label: 'Energy loss (kWh)',
                            data: data[0],
                            backgroundColor: 'rgba(75,137,192, 0.2)',
                            borderColor: 'rgb(75,137,192)',
                            borderWidth: 1,
                        },
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            labels: groupLabel1,
                        },
                        x2: {
                            labels: groupLabel2,
                        },
                        y: {
                            beginAtZero: true,

                        }
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },

                        title: {
                            display: true,
                            text: `${str_dist} - Circuit Losses`
                        },
                        subtitle: {
                            display: true,
                            text: 'DO - ' + ano + ' - ' + mes
                        }
                    },
                    responsive: true,
                }
            });
            myChart1.options.plugins.legend.align = 'end';
            myChart1.update();

            const myChart2 = new Chart(ctx2, {
                type: 'bar',
                data: {
                    datasets: [
                        {
                            label: 'Energy loss (kWh)',
                            data: data[3],
                            backgroundColor: 'rgba(75,137,192, 0.2)',
                            borderColor: 'rgb(75,137,192)',
                            borderWidth: 1,
                        },
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            labels: groupLabel1,
                        },
                        x2: {
                            labels: groupLabel2,
                        },
                        y: {
                            beginAtZero: true,

                        }
                    },
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'x',
                                onPanComplete: ({chart}) => {
                                    console.log(`chart onPanComplete`)
                                },
                            },
                            zoom: {
                                wheel: {
                                    enabled: true,
                                },
                                mode: 'x',
                                onZoomComplete: ({chart}) => {
                                    console.log(`chart onZoomComplete`)
                                },
                            }
                        },

                        title: {
                            display: true,
                            text: `${str_dist} - Circuit Losses`
                        },
                        subtitle: {
                            display: true,
                            text: 'DU - ' + ano + ' - ' + mes
                        }
                    },
                    responsive: true,
                }
            });
            myChart2.options.plugins.legend.align = 'end';
            myChart2.update();
        })
        .catch(error => console.error('Error loading chart data:', error));
}


function removeCanvas(num_chart) {
    for (let i = 1; i <= num_chart; i++) {
        const canvas = document.getElementById('myChart' + i);
        console.log('RemoveCanvas:');
        console.log(canvas);
        if (canvas) { // Check if the canvas element exists before trying to remove it
            const parentNode = canvas.parentNode;
            parentNode.removeChild(canvas);
        }
    }
}
function removedivChart(num_chart) {
    for (let i = 1; i <= num_chart; i++) {
        const myDiv = document.getElementById('chart' + i);
        //console.log('RemoveDIVChart:');
        //console.log(myDiv);
        if (myDiv) { // Check if the element exists before trying to remove it
            const parentNode = myDiv.parentNode;
            parentNode.removeChild(myDiv);
        }
    }
}

function createCanvas(num_chart) {
    const elementeExist =  document.getElementById('myChart1');

    if (elementeExist){
        console.log(elementeExist)
        return;
    }
    const chartContainer = document.getElementById(`chart-container`);
    for (let i = 1; i <= num_chart; i++) {
        const graphDiv = document.createElement('canvas');
        graphDiv.id = `myChart${i}`;
        //graphDiv.style.width = '58vh';
        graphDiv.style.display = 'inline-block';
        chartContainer.appendChild(graphDiv);
    }
}

function destroy_charts(num_chart) {
    for (let i = 1; i <= num_chart; i++) {
        try {
            var exist_char = Chart.getChart('myChart' + i);
                exist_char.destroy();
            } catch(e) {
               console.log('chart does not exist yet to destroy');
            }
    }
    Plotly.purge('chart-container');
}

function createEventChart(){
    // Objeto para guardar o estado de cada div
    const divEstados = new WeakMap();

    // Seleciona todos os divs com a classe
    const divs = document.querySelectorAll(".js-plotly-plot");
    console.log('divs');
    console.log(divs);
    divs.forEach(div => {

        div.addEventListener("dblclick", () => {
            const estadoAtual = divEstados.get(div) || {
                isMaximized: false,
                width: div.offsetWidth + "px",
                height: div.offsetHeight + "px",
                top: div.offsetTop + "px",
                left: div.offsetLeft + "px",
                position: getComputedStyle(div).position
            };

            if (!estadoAtual.isMaximized) {
                // Maximiza o painel
                div.style.position = "fixed";
                div.style.top = "0";
                div.style.left = "0";
                div.style.width = "100vw";
                div.style.height = "100vh";
                div.style.zIndex = "9999";

                divEstados.set(div, { ...estadoAtual, isMaximized: true });

            } else {
                // Restaura para o tamanho original
                div.style.position = estadoAtual.position;
                div.style.top = estadoAtual.top;
                div.style.left = estadoAtual.left;
                div.style.width = estadoAtual.width;
                div.style.height = estadoAtual.height;
                div.style.zIndex = "";

                divEstados.set(div, { ...estadoAtual, isMaximized: false });
            }
            Plotly.Plots.resize(div);
        });
    });
 };


