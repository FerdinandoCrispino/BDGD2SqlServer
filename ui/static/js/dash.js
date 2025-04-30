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
            const x = data[0].slice(1); // Primeira linha (exceto o primeiro valor) = eixo X
            const y = data.slice(1).map(row => row[0]); // Primeira coluna (exceto o cabeçalho) = eixo Y
            const z = data.slice(1).map(row => row.slice(1)); // Valores Z
            //console.log (x)
            //console.log (y)
            //console.log (z)
            const surf_data = [{
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
            var layout = {
                title: {
                    text: 'DER´s Insertion Analysis: ' + sub +': '+ circ +' '+ tipo_dia +' '+ano +'/'+ mes + '<br>' + txt_title
                },
                scene: {
                    xaxis: { title: { text: 'PV Penetration %' } },
                    yaxis: { title: { text: 'Buses %' } },
                    zaxis: { title: { text: 'Probability %' } }
                },
                autosize: false,
                width: 800,
                height: 700,
                margin: {
                    l: 65,
                    r: 20,
                    b: 65,
                    t: 30,
                }
            };

            destroy_charts(4);

            Plotly.newPlot('chart-container', surf_data, layout);

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
            myChart1.options.plugins.subtitle.text = 'Sundays - ' + ano + '- ' + mes;
            if (num_lines > max_legend) {
                myChart1.options.plugins.legend.display = false
                //myChart1.defaults.global.legend.display = false
            }
            myChart1.update();
            myChart2.options.plugins.legend.align = 'end';
            myChart2.options.plugins.subtitle.text = 'Workdays - '+ ano + ' - ' + mes;
            if (num_lines > max_legend) {
                myChart2.options.plugins.legend.display = false
                //myChart2.defaults.global.legend.display = false
            }
            myChart2.update();

        })
        .catch(error => console.log('Error loading chart data:', error));
    document.body.style.cursor = 'default';  // Cursor normal
}


function transformer_loading(dist) {
    // Captura o valor do parâmetro 'dist' da URL
    //const dist = "{{ dist }}";
    document.body.style.cursor = 'wait';  // Cursor de espera
    fetch(`/data/${dist}`)  // Atenção ao tipo de aspas - backticks
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
            for (const [key, val] of Object.entries(data[1])) {
                groupLabel2.push(val)
            }
            for (const [key] of Object.entries(data[0])) {
                groupLabel1.push(key)
            }
            console.log(groupLabel1)
            console.log(groupLabel2)
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