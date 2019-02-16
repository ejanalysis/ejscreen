if (1==0) {
  formulastoexcel <-
    function(x = ejscreenformulas,
             filename = 'excelformulas.csv',
             rangenames = FALSE,
             maxrow = 250000,
             folder = getwd(),
             wtscolname = 'pop') {
      # WORK IN PROGRESS...
      
      # Code to create Excel formulas in a spreadsheet that can calculate EJSCREEN dataset from raw ACS and Envt fields.
      # Based on ejscreenformulas (tabular data version of formulas)
      #  **** IF TRUE, MUST CREATE RANGENAMES IN EXCEL TABULAR DATA BASED ON Rfieldnames
      ################################################################################# #
      
      # ISSUES:
      
      # *** *** much too slow in excel since every cell has sum of range!
      # need to update it to do those calcs only once, in pctile. formulas using sumif().
      
      # *** *** Same issue applies to US totals: VSI.eo.US	and VSI.svi6.US
      
      # **** fails to create absolute references that work,
      # for the weighted percentiles.
      
      # ***NOTE: THIS IS JUST ONE APPROXIMATE WAY TO CALCULATE A PERCENTILE. IT MAY NOT BE EXACTLY HOW EJSCREEN DOES IT.
      
      # it does not create popup text fields
      
      ################################################################################# #
      
      #require(ejscreen)
      #x <- ejscreenformulas
      
      # also needs x$formula, and x$Rfieldname which must have pctile..., bin..., etc. as Rfieldname values
      
      # names(ejscreenformulas)
      # [1] "gdbfieldname"      "Rfieldname"
      # [3] "acsfieldname"      "type"
      # [5] "glossaryfieldname" "formula"
      # [7] "acsfieldnamelong"  "universe"
      #
      # t(ejscreenformulas[c(3),])
      # 3
      # gdbfieldname      "ACSTOTPOP"
      # Rfieldname        "pop"
      # acsfieldname      "B01001.001"
      # type              "Demographic"
      # glossaryfieldname "Total population"
      # formula           NA
      # acsfieldnamelong  "Total:|SEX BY AGE"
      # universe          "Universe:  Total population"
      #
      # t(ejscreenformulas[c(57),])
      # 57
      # gdbfieldname      NA
      # Rfieldname        "num1pov"
      # acsfieldname      NA
      # type              "Calc from ACS"
      # glossaryfieldname NA
      # formula           "num1pov <- pov50 + pov99"
      # acsfieldnamelong  "(count in poverty -- RATIO OF INCOME TO POVERTY LEVEL IN THE PAST 12 MONTHS was less than 1)"
      # universe          NA
      
      ########################################## #
      # A, B, C... Z, AA, AB, AC, ...AZ, BA, BB, ...ZZ
      # create column letters for excel up to 26+ 26*26=702 columns
      # , which should be enough (470 needed right now for ejscreenformulas)
      exceletters <-
        expand.grid(LETTERS[1:26], LETTERS[1:26], stringsAsFactors = FALSE)
      exceletters <- paste(exceletters[, 2], exceletters[, 1], sep = '')
      exceletters <- c(LETTERS, exceletters)
      exceletters <-
        exceletters[1:NROW(x)]  # so that a logical index as long as x rows but shorter than exceletters will not be recycled
      ########################################## #
      
      wtscol <- exceletters[x$Rfieldname == wtscolname]
      
      excol <- 1:NROW(x)
      # xrow, the rownum to reference in spreadsheet, will be the next colnum in x here
      exrow <-
        2 + NCOL(x) # added 1+1 because it is the next available row  and header row gets added to excel after t()
      cellref <- paste(exceletters[excol], exrow, sep = '')
      
      # sort the Rfieldnames and cellref by longest Rfieldname to shortest,
      # so that partial matches will not occur on short portion of long Rfieldname like pctlowinc changed to pctAA9
      ls.Rfieldname <-
        x$Rfieldname[order(nchar(x$Rfieldname), decreasing = TRUE)]
      ls.cellref <-
        cellref[order(nchar(x$Rfieldname), decreasing = TRUE)]
      
      exform <- x$formula
      exform[is.na(x$formula)] <-
        0 # but gets wiped out by character formulas, NA
      
      ################################### #
      for (i in 1:NROW(x)) {
        exform <- gsub(ls.Rfieldname[i], ls.cellref[i], exform)
      }
      ################################### #
      
      exform <- gsub('.*<-', '', exform)
      exform <- gsub('==', '=', exform)
      exform <- gsub('ifelse', 'IF', exform)
      exform <- gsub('as.numeric', '', exform)
      #exform <- trimws(exform)
      exform <- gsub(' ', '', exform)
      exform <- paste('=', exform)
      
      isform <- !is.na(x$formula)
      x$excelformula[isform] <- exform[isform]
      #cbind( strtrim(x$formula,40), cellref, strtrim(x$excelformula,40))[isform, ]
      
      ######################################## #
      # *** need to fix to use generic rownumber in sum()
      # Fix the two that need to be column sums in excel
      #
      # *** *** But this is much too slow in excel since every cell has sum of range!
      # Instead, will need to calculate these two numbers once, not again in each row.
      #
      # [1,] "VSI.eo.US <- ( sum(mins) / sum(pop)  +  sum(lowinc) / sum(povknownratio) ) / 2"
      # [2,] "VSI.svi6.US <- (sum(mins) / sum(pop) + sum(lowinc) / sum(povknownratio) + sum(lths) / sum(age25up) + sum(lingiso) / sum(hhlds) + sum(over64) / sum(pop) + sum(under5) / sum(pop) ) / 6"
      # cellref
      
      isumform <- isform & grepl('sum', x$excelformula)
      x$excelformula[isumform] <-
        gsub('sum\\(([A-Z]*)([0-9]*)\\)',
             'SUM($\\1$\\2:$\\1$250000)',
             x$excelformula[isumform])
      
      
      ################################### #
      # Fix percentile and bin formulas
      #
      # *** But much too slow in excel this way...****
      # Would be faster recalc if only took sum of weights once, not in every row of every pctile column!
      # Could instead create/insert a sumtotal row above formulas and use that cell (just the wts col's totals row).
      #
      # ***NOTE: THIS IS JUST ONE APPROXIMATE WAY TO CALCULATE A PERCENTILE. IT MAY NOT BE EXACTLY HOW EJSCREEN DOES IT.
      # on percentile() in excel, see http://answers.microsoft.com/en-us/office/forum/office_2010-excel/percentileexce-versus-percentilinc/7eb2796a-b555-445b-a8cd-eee716c6291d?auth=1
      # A basic weighted percentile formula for value in A and weights in W:
      # =SUMIF($A$1:$A$250000,"<"&A1,$W$1:$W$250000) / SUM($W$1:$W$250000)
      
      excel.wtd.pctile <-
        function(excol = 'A',
                 wtscol = 'B',
                 exrow = 1,
                 maxrow = 250000,
                 rangenames = FALSE) {
          if (!rangenames) {
            results = paste(
              '=SUMIF(',
              '$',
              excol,
              '$',
              exrow,
              ':$',
              excol,
              '$',
              maxrow,
              ', "<"&',
              excol,
              exrow,
              ', ',
              '$',
              wtscol,
              '$',
              exrow,
              ':$',
              wtscol,
              '$',
              maxrow,
              ') / SUM(',
              '$',
              wtscol,
              '$',
              exrow,
              ':$',
              wtscol,
              '$',
              maxrow,
              ')',
              sep = ''
            )
            
          } else {
            # use range names for columns in excel, excol will be names not letters, and exrow ignored
            results = paste('=SUMIF(',
                            excol,
                            ', "<"&',
                            excol,
                            ', ',
                            wtscol,
                            ') / SUM(',
                            wtscol,
                            ')',
                            sep = '')
            
          }
          return(results)
        }
      
      is.pctilecol <-
        grepl('^pctile.', gsub('^pctile.text', '', x$Rfieldname))
      basecolname <- gsub('^pctile.', '', x$Rfieldname[is.pctilecol])
      basecoletter <- exceletters[match(basecolname, x$Rfieldname)]
      #p.excol <- exceletters[is.pctilecol]
      
      
      if (rangenames) {
        pctile.forms <-
          excel.wtd.pctile(
            excol = basecolname,
            wtscol = wtscol,
            rangenames = rangenames,
            maxrow = maxrow
          )
      } else {
        pctile.forms <-
          excel.wtd.pctile(
            excol = basecoletter,
            wtscol = wtscol,
            exrow = exrow,
            rangenames = rangenames
          )
      }
      
      x$excelformula[is.pctilecol] <- pctile.forms
      # take a look
      # cbind(x$Rfieldname[!is.na(x$excelformula)], cellref[!is.na(x$excelformula)]  , strtrim(x$excelformula[!is.na(x$excelformula)], 52))
      
      ################################### #
      # create bins, e.g.
      #  =IF(A2>89,"A",IF(A2>79,"B",IF(A2>69,"C",IF(A2>59,"D","F"))))
      
      excel.bin <- function(excol = 'A',
                            exrow = 1,
                            rangenames = FALSE) {
        #   results <- '= IF(cell="NA",0,
        #   IF(cell>=0,1,
        #   IF(cell>=0.1,2,
        #   IF(cell>=0.2,3,
        #   IF(cell>=0.3,4,
        #   IF(cell>=0.4,5,
        #   IF(cell>=0.5,6,
        #   IF(cell>=0.6,7,
        #   IF(cell>=0.7,8,
        #   IF(cell>=0.8,9,
        #   IF(cell>=0.9,10,
        #   IF(cell>=0.95,11,12))))))))))))'
        if (!rangenames) {
          cells <- paste(excol, exrow, sep = '')
        } else {
          # if rangenames in excel, just use fieldname (rangename)
          cells <- excol
        }
        results <- paste(
          '= IF(ISBLANK(',
          cells,
          '),0, IF(',
          cells,
          '>1,-1, IF(',
          cells,
          '>=0.95,11, IF(',
          cells,
          '>=0.9,10, IF(',
          cells,
          '>=0.8,9, IF(',
          cells,
          '>=0.7,8, IF(',
          cells,
          '>=0.6,7, IF(',
          cells,
          '>=0.5,6, IF(',
          cells,
          '>=0.4,5, IF(',
          cells,
          '>=0.3,4, IF(',
          cells,
          '>=0.2,3, IF(',
          cells,
          '>=0.1,2,1))))))))))))',
          sep = ''
        )
        
        return(results)
      }
      
      is.bincol <- grepl('^bin.', x$Rfieldname)
      basecolname <- gsub('^bin.', 'pctile.', x$Rfieldname[is.bincol])
      
      basecoletter <- exceletters[match(basecolname, x$Rfieldname)]
      #b.excol <- exceletters[is.bincol]
      
      if (rangenames) {
        bin.forms <-
          excel.bin(excol = basecolname,
                    exrow = exrow,
                    rangenames = TRUE)
      } else {
        bin.forms <-
          excel.bin(excol = basecoletter,
                    exrow = exrow,
                    rangenames = FALSE)
      }
      
      x$excelformula[is.bincol] <- bin.forms
      # take a look
      # cbind( strtrim(x$formula,40), cellref, strtrim(x$excelformula,40))[isform, ]
      
      
      ################################### #
      
      y <- t(x)
      #y[exrow-1 , is.na(x$formula)] <- 0 # need -1 since header row added by write.csv is not actually in y
      
      write.csv(y,
                row.names = FALSE,
                file = filename,
                folder = folder)
      
      #  ****** lacks popups pctile.text fields
      
    }
  
  
}
