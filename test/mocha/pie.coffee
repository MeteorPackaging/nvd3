describe 'NVD3', ->
    describe 'Pie Chart', ->
        sampleData1 = [
            {label: 'America', value: 100}
            {label: 'Europe', value: 200}
            {label: 'Asia', value: 50}
            {label: 'Africa', value: 70}
        ]

        options =
            x: (d)-> d.label
            y: (d)-> d.value
            margin:
                top: 30
                right: 20
                bottom: 50
                left: 75
            width: 200
            height: 200
            color: nv.utils.defaultColor()
            showLegend: true
            valueFormat: (d)-> d.toFixed 2
            showLabels: true
            donutLabelsOutside: false
            pieLabelsOutside: true
            donut: false
            donutRatio: 0.5
            labelThreshold: 0.02
            labelType: 'key'
            tooltips: true
            tooltipContent: (key,x,y)-> "<h3>#{key}</h3>"
            noData: 'No Data Available'
            duration: 0
            startAngle: false
            endAngle: false
            padAngle: false
            cornerRadius: 0
            labelSunbeamLayout: false

        builder = null
        beforeEach ->
            builder = new ChartBuilder nv.models.pieChart()
            builder.build options, sampleData1

        afterEach ->
            builder.teardown()

        it 'api check', ->
            for opt of options
                should.exist builder.model[opt](), "#{opt} can be called"

        describe 'renders', ->

            wrap = null
            labels = null

            beforeEach ->
              wrap = builder.$ 'g.nvd3.nv-pieChart'
              labels = wrap[0].querySelectorAll('.nv-label text')

            it '.nv-pieChart', ->
              should.exist wrap[0]

            it 'can access margin', ->
              builder.model.margin
                top: 31
                right: 21
                bottom: 51
                left: 76

              m = builder.model.margin()
              m.should.deep.equal 
                top: 31
                right: 21
                bottom: 51
                left: 76

            describe 'labels correctly', ->
              it "[#{sampleData1.length}] labels", ->
                wrap[0].querySelectorAll('.nv-label').should.have.length sampleData1.length

              for item, i in sampleData1
                do (item, i) ->
                  it "label '#{item.label}'", ->
                    item.label.should.be.equal labels[i].textContent

        it 'has correct structure', ->
          cssClasses = [
            '.nv-pieWrap'
            '.nv-pie'
            '.nv-pieLabels'
            '.nv-legendWrap'
          ]
          for cssClass in cssClasses
            do (cssClass) ->
              should.exist builder.$("g.nvd3.nv-pieChart #{cssClass}")[0]

        it 'can handle donut mode and options', (done)->
            builder.teardown()
            options.donut = true
            options.donutLabelsOutside = true
            options.labelSunbeamLayout = true
            options.startAngle = (d)-> d.startAngle/2 - Math.PI/2
            options.endAngle = (d)-> d.endAngle/2 - Math.PI/2

            builder.build options, sampleData1

            done()

        it 'can handle cornerRadius and padAngle options', (done)->
            builder.teardown()
            options.padAngle = 5
            options.cornerRadius = 5

            builder.build options, sampleData1
            done() 
