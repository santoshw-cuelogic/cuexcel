module ApplicationHelper

  def to_csv(header, rows)
    CSV.generate({}) do |csv|
      csv << header
      rows.each do |data|
        csv << data
      end
    end
  end

  def xls_content(path, options)

    content = "<?xml version='1.0'?>\n"

    content << "<Workbook xmlns='urn:schemas-microsoft-com:office:spreadsheet'
                          xmlns:o='urn:schemas-microsoft-com:office:office'
                          xmlns:x='urn:schemas-microsoft-com:office:excel'
                          xmlns:ss='urn:schemas-microsoft-com:office:spreadsheet'
                          xmlns:html='http://www.w3.org/TR/REC-html40'>\n"

    content << "<ExcelWorkbook xmlns='urn:schemas-microsoft-com:office:excel'>
                    <WindowHeight>    #{ (options[:window_height]     || 6030) }  </WindowHeight>
                    <WindowWidth>     #{ (options[:window_width]      || 10020) } </WindowWidth>
                    <WindowTopX>      #{ (options[:window_top_x]      || -45) }   </WindowTopX>
                    <WindowTopY>      #{ (options[:window_to_y]       || -45) }   </WindowTopY>
                    <ActiveSheet>     #{ (options[:active_sheet]      || 2) }     </ActiveSheet>
                    <ProtectStructure>#{ (options[:protect_structure] || 'False') } </ProtectStructure>
                    <ProtectWindows>  #{ (options[:protect_windows]   || 'False') } </ProtectWindows>
                  </ExcelWorkbook>\n"

    content << '<Styles>
                      <Style ss:ID="Default" ss:Name="Normal">
                          <Alignment ss:Vertical="Bottom"/>
                          <Borders/>
                          <Font/>
                          <Interior/>
                          <NumberFormat/>
                          <Protection/>
                      </Style>

                      <Style ss:ID="s6">
                            <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>
                            <Borders>
                             <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
                            </Borders>
                              <Font x:Family="Swiss" ss:Size="12" ss:Color="#000000" ss:FontName="Calibri"/>
                            <Interior ss:Color="#E8E8E8" ss:Pattern="Solid"/>
                            <Protection x:HideFormula="1"/>
                      </Style>

                      <Style ss:ID="s15">
                            <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>
                            <Borders>
                             <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
                            </Borders>
                              <Font x:Family="Swiss" ss:Size="11" ss:FontName="Calibri"/>
                            <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;0.00&quot;??_);_(@_)"/>
                            <Protection ss:Protected="0"/>
                      </Style>

                      <Style ss:ID="s19">
                            <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:WrapText="1"/>
                            <Borders>
                             <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
                            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
                            </Borders>
                              <Font x:Family="Swiss" ss:Size="11" ss:FontName="Calibri"/>
                            <Protection ss:Protected="0"/>
                        </Style>

                      <Style ss:ID="s22">
                            <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" />
                            <Font x:Family="Swiss" ss:Size="14" ss:Color="#000000" ss:FontName="Calibri" />
                            <Protection x:HideFormula="1"/>
                      </Style>
                   </Styles>'

    content << "<Worksheet ss:Name='#{options[:worksheet_name]}'>\n"
    content << "<Table>\n"

    ##### Column start #######
    options[:column_width].each do |col|
      column_content = "<Column ss:AutoFitWidth='1' "
      column_content << "ss:Width= '#{col}'"
      options[:column_attr].each{|k,v| column_content << ' ss:'+k.to_s.camelize+'='+v }
      column_content << "/>\n"
      content << column_content
    end
    ###### Column end ########

    ##### Title start #######
    options[:titles].each do |tt|
      content << "<Row ss:AutoFitHeight='1' ss:Height='20'>
                      <Cell ss:StyleID='s22' ss:MergeAcross='6'><Data ss:Type='String'>#{tt}</Data></Cell>
                  </Row>\n"
    end
    ###### Title end ########

    ##### Table Header start #######
    content << "<Row ss:AutoFitHeight='1' ss:Height='20'>\n"
    options[:header].each do |header|
      content << "<Cell ss:StyleID='s6'><Data ss:Type='String'>#{header}</Data></Cell>\n"
    end
    content << "</Row>\n"
    ###### Table Header end ########

    ##### Data start #######
    options[:data].each do |data|
      content << "<Row ss:AutoFitHeight='1' ss:Height='20'>\n"
      options[:column_width].count.times.each do |index|
        content << "<Cell ss:StyleID='s15'><Data ss:Type='String'>#{data[index]}</Data></Cell>\n"
      end
      content << "</Row>\n"
    end
    ###### Data end ########

    content << "</Table>\n"
    content << "<WorksheetOptions xmlns='urn:schemas-microsoft-com:office:excel'>
                      <PageSetup>
                        <Layout x:CenterHorizontal='1'/>
                        <PageMargins x:Left='0.63' x:Right='0.58'/>
                      </PageSetup>
                      <DisplayPageBreak/>
                      <Print>
                        <ValidPrinterInfo/>
                        <HorizontalResolution>#{ (options[:horizontal_resolution]   || 600) }</HorizontalResolution>
                        <VerticalResolution>  #{ (options[:vertical_resolution]     || 600) }</VerticalResolution>
                      </Print>
                      <DoNotDisplayGridlines/>
                      <TopRowVisible>#{ (options[:top_row_visible] || 3) }</TopRowVisible>
                      <Panes>
                        <Pane>
                          <Number>   #{ (options[:number]     || 3) }</Number>
                          <ActiveRow>#{ (options[:active_row] || 15) }</ActiveRow>
                          <ActiveCol>#{ (options[:active_col] || 6) }</ActiveCol>
                        </Pane>
                      </Panes>
                      <ProtectObjects>  #{ (options[:protect_objects]   || 'False') }</ProtectObjects>
                      <ProtectScenarios>#{ (options[:protect_scenarios] || 'False') }</ProtectScenarios>
                    </WorksheetOptions>"

    content << "</Worksheet>\n"
    content << "</Workbook>\n"

    File.write(path, content)

  end
end
