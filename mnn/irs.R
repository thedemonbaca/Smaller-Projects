## Functions for handling IRS data
### Assume that we've made all of the state's file one CSV file

### Codes from  http://www.irs.gov/file_source/pub/irs-soi/eobk13.doc
affil.codes <-
    c("1"="Parent.No.Grp.Exempt", "2"="Intermed.No.Grp.Exempt",
      "3"="Indepedent", "6"="Parent.Grp.Ruling.Non.Church",
      "7"="Intermediate.Grp.Exempt", "8"="Parent.Grp.Ruling.Church",
      "9"="Subordinate")

foundation.codes <- c("00"="Not.c3", "02"="Priv.Op.Fndatn.No.Excise",
                      "03"="Priv.Op.Found.Other", "04"="Private.Non.Op",
                      "09"="Suspense", "10"="Church", "11"="School",
                      "12"="Hospital", "13"="Govt.Unit.College",
                      "14"="Govt.Unit", "15"="Pub.Supported",
                      "16"="Contrib.Supported", "17"="Adjunct",
                      "18"="Pub.Safety.509a4", "21"="509a3.I",
                      "22"="509a3.II", "23"="509a3.III.Integrated", "21"="509a3.III.Non.Integrated")

org.codes <- c("1"="Corporation", "2"="Trust", "3"="Coop", "4"="Partnership","5"="Association")

### Function to load MNN data, filtering for target orgs
mmn.load.exempt.org <- function (csv.file,strip.white=T,
                                 class.code.file="../irs_class_codes.txt",
                                 ntee.code.file = "../ntee_codes.txt",
                                 typo.file="../edited_typos_1.txt",
                                 group.file="../groups.txt")
{
    dat <- read.csv (csv.file, header=T, colClasses=c
                     ("EIN"="factor",
                      "Group.Exemption.Number"="factor",
                      "Subsection.Code"="factor",
                      "Activity.Code"="factor",
                      "Asset.Code"="factor",
                      "Income.Code"="factor",
                      "Organization.Code"="factor",
                      "Exempt.Organization.Status.Code"="factor",
                      "Blank"=NULL,
                      "PF.Filing.Requirement.Code"="factor"))
        amt.cols <- c("Asset.Amount", "Income.Amount", "Form.990.Revenue.Amount")
    for (col in amt.cols) {
        dollar <- dat[[col]]
        dollar <- sub(dollar, patt="\\s+", repl="", perl=T)
        dollar[dollar == ""] <- NA
        dollar <- gsub(x=dollar, patt="(\\$|,)", repl="")
        dollar <- as.numeric(dollar)
        if (col == "Income.Amount") {
            dollar <- dollar * ifelse(!is.na(dat$Negative.Sign) & dat$Negative.Sign == "-", -1, 1)
        }
        if (col == "Form.990.Revenue.Amount") {
            dollar <- dollar * ifelse(!is.na(dat$Negative.Sign.1) & dat$Negative.Sign.1 == "-", -1, 1)
        }
        dat[[col]] <- dollar

    }
    dat[["Negative.Sign"]] <- NULL
    dat[["Negative.Sign.1"]] <- NULL
    eo.class <- mmn.compute.class.codes(dat, class.code.file)
    dat$Classification <- eo.class
    ntee.codes <- mmn.compute.ntee.codes (dat, ntee.code.file)
    dat <- data.frame(dat, ntee.codes)
    ruling.date <- paste(as.character(dat$Ruling.Date), "20", sep="")
    cur.date <- "20130720"
    secs <- as.POSIXct(strptime(cur.date, format="%Y%m%d")) - as.POSIXct(strptime(ruling.date, format="%Y%m%d"))
    years <- secs / (365 * 24 * 3600)
    dat$Years.Exempt <- years
    dat$Affiliation.Type <- factor(affil.codes[match(as.character(dat$Affiliation.Code), names(affil.codes))])
    dat$Foundation.Type <- factor(foundation.codes[match(as.character(dat$Foundation.Code), names(foundation.codes))])
    dat$Org.Type <- factor(org.codes[match(as.character(dat$Organization.Code), names(org.codes))])
    fixed.names <- irs.fix.typos(dat, typo.file)
    dat$Fixed.Typos <- factor(fixed.names)
    group.names <- irs.get.group.names (fixed.names, group.file)
#    group.names <- factor(group.names, lev=levels(dat$Name))
    dat$Group.Name <- factor(group.names)
    return (dat)
}


mmn.compute.class.codes <- function (dat, class.code.file)
{
    ## Read in the class code file, which has leading spaces and multiple spaces between each column.
    ## Sort of ugly but works (better would be to use regexps to parse lines properly)typo.file="../edited_typos_1.txt")
    lines <- readLines(class.code.file)
    split.lines <- strsplit (lines, split="\\s{2,}")
    subsect.code <- sapply (split.lines, function (x) x[2])
    subsect.code <- sub(x=subsect.code, patt="^0", repl="")
    class.code <- sapply (split.lines, function (x) x[3])
    org.class <- sapply (split.lines, function (x) x[4])
    concat.code <- paste(subsect.code, class.code, sep=".")
    dat.lookup <- paste(as.character(dat$Subsection.Code),
                        as.character(dat$Classification.Code), sep=".")
    rv <- org.class[match(dat.lookup, concat.code)]
    rv <- factor(rv)
    return(rv)
}

mmn.compute.ntee.codes <- function (dat, ntee.code.file)
{
    fields <- scan(ntee.code.file, sep="\t", what="", quote=NULL)
    code.field.ids <- grep(fields, patt="[A-Z]\\d\\d", perl=T)
    code.fields <- fields[code.field.ids]
    code.field.vals <- fields[code.field.ids+1]
    code.field.vals <- sub(x=code.field.vals, patt="^\\s+", repl="")
    code.field.vals <- sub(x=code.field.vals, patt="\\s+$", repl="")
    broad.field.ids <- grep(fields, patt="^\\s*[A-Z]\\s*$", perl=T)
    broad.fields <- fields[broad.field.ids]
    broad.fields <- sub(x=broad.fields, patt="^\\s+", repl="")
    broad.fields <- sub(x=broad.fields, patt="\\s+$", repl="")
    broad.field.vals <- fields[broad.field.ids+1]
    broad.field.vals <- sub(x=broad.field.vals, patt="^\\s+", repl="")
    broad.field.vals <- sub(x=broad.field.vals, patt="\\s+$", repl="")
    ntee.code <- as.character(dat$NTEE.Code)
    ntee.code <- sub(x=ntee.code, patt="^\\s+", repl="")
    ntee.code <- sub(x=ntee.code, patt="\\s+$", repl="")
    ntee.code <- substr(ntee.code, 1,3)
    ntee.val <- code.field.vals[match(ntee.code, code.fields)]
    ntee.broad.code <- substr(ntee.code, 1,1)
    ntee.broad.val <- broad.field.vals[match(ntee.broad.code, broad.fields)]
    rv <- list (NTEE.Common=ntee.broad.val, NTEE.Narrow=ntee.val)
    return (rv)
}

irs.get.parents <- function (dat)
{
    name <- as.character(dat$Name)
    name <- toupper(name)
    name <- gsub (name, patt="\\s+&\\s+", " AND ", perl=T)
}

irs.small.samp.with.type <- function (dat, use.abbrev=F)
{
    abbrevs <- c("Corporation" = "Corp",
                 "Education" = "Edu",
                 "Charitable" = "Char",
                 "Organization" = "Org",
                 "Association" = "Assn",
                 "Government" = "Govt")


    dat$Subsection.Code <- as.integer(as.character(dat$Subsection.Code))
    types <- c("Subsection.Code", "NTEE.Common", "NTEE.Narrow", "Classification",  "Foundation.Type", "Org.Type", "Affiliation.Type")
    rv <- dat[sample(nrow(dat), 1000), c("Name", types)]
    rv <- rv[order(rv$Subsection.Code, rv$NTEE.Common, rv$NTEE.Narrow, rv$Foundation.Type, rv$Classification, rv$Org.Type, rv$Affiliation.Type, rv$Name),]
    if (use.abbrev) {
        for (field in names(rv)) {
            f <- as.character(rv[[field]])
            for (i.abb in seq(along=abbrevs)) {
                f <- gsub (x=f, patt=names(abbrevs)[i.abb], repl=abbrevs[i.abb], fixed=T)
                rv[[field]] <- factor(f)
            }
        }
    }
    return (rv)
}

is.first.instance <- function(x)
{
  !duplicated(x)
}
is.last.instance <- function(x)
{
  rev(!duplicated(rev(x)))
}

# Print table of top N
top <- function(x, n=10, prop=F) {
  y <- rev(sort(table(x)))[1:n]
  retval <- y[!is.na(y) & y>0]
  if (prop) retval <- retval/length(x)
  return(retval)

}

## Finds typos by finding pairs of words with very low edit distances
## Writes them to a file for human review
find.typos <- function (strings, out.file="../typos.txt",
                        min.dist=1, remove.short=F)
{
    strings <- as.character(strings)
    cl.strings <- strings
    cl.strings <- gsub (x=cl.strings, patt="\\s+&\\s+", repl=" AND ", perl=T)
    cl.strings <- gsub(patt="^\\s+", x=cl.strings, repl="")
    cl.strings <- gsub(patt="\\s+$", x=cl.strings, repl="")
    cl.strings <- gsub(patt="\\s+", x=cl.strings, repl=" ")
    uniq <- unique(cl.strings)
    if (remove.short) {
        freqs <- irs.word.tab(uniq)
        words <- names(freqs)
        fillers <- words[freqs >= 15]
        word.len <- sapply (words, nchar)
        content.words <- words[word.len <= 4 & !(words %in% fillers)]
        split.words <- strsplit(x=uniq, split="\\s+")
        split.words.no.content <- lapply (split.words, function (x) setdiff(x, content.words))
        targ.names <- sapply (split.words.no.content, paste, collapse=" ")
    }
    else {
        targ.names <- uniq
    }
    rv <- list()
    cat ("", file=out.file, append=F)
    all.near <- character(0)
    n.targs <- length(targ.names)
    for (i in 1:(n.targs-1)){
        if (i %% 10 == 0) {
            cat ("working on word ", i, "\r")
        }
        ref <- targ.names[i]
        targ <-  targ.names[(i+1):n.targs]
        lev.d <- as.vector(adist(ref, targ))
        near <- which (lev.d >=1 & lev.d <= min.dist & !(targ %in% all.near))
        if (length (near)) {
            exemp.sent <- uniq[i]
            replace.sent <- uniq[i+near]
            typos <- targ.names[i+near]
            all.near <- c(all.near, typos)
            rv[[exemp.sent]] <- replace.sent
            cat (exemp.sent, ":", paste(replace.sent, collapse=", "), "\n", sep="", file=out.file, append=T)
        }
    }
    return(rv)
}

irs.word.tab <- function (names)
{
    names <- as.character(names)
    all.words <- strsplit(x=unique(names), split="\\s+")
    return (top (unlist(all.words), 100000))
}

irs.fix.typos <- function (dat, typo.file="../edited_typos_1.txt")
{
    x <- as.character (dat$Name)
    x <- clean.string(x)
    fix.lines <- readLines (typo.file)
    comment.lines <- grep (x=fix.lines, patt="^#")
    cat ("Found ", length(comment.lines), " comment.lines\n")
    fix.lines <- fix.lines[-comment.lines]
    translate <- strsplit(fix.lines, split="\\s*:\\s*")
    for (i.fix in seq(along=translate)) {
        clean <- translate[[i.fix]][1]
        dirty <- strsplit (translate[[i.fix]][2], split="\\s*,\\s*")[[1]]
        x[x %in% dirty] <- clean
    }
    return(x)
}

irs.fix.typos <- function (dat, typo.file="../edited_typos_1.txt")
{
    x <- as.character (dat$Name)
    x <- clean.string(x)
    fix.lines <- readLines (typo.file)
    comment.lines <- grep (x=fix.lines, patt="^#")
    cat ("Found ", length(comment.lines), " comment.lines\n")
    fix.lines <- fix.lines[-comment.lines]
    translate <- strsplit(fix.lines, split="\\s*:\\s*")
    for (i.fix in seq(along=translate)) {
        clean <- translate[[i.fix]][1]
        dirty <- strsplit (translate[[i.fix]][2], split="\\s*,\\s*")[[1]]
        x[x %in% dirty] <- clean
    }
    return(x)
}


irs.get.group.names<- function (clean.names, group.file="../groups.txt")
{
    x <- clean.names
    x <- clean.string(x)
    fix.lines <- readLines (group.file)
    comment.lines <- grep (x=fix.lines, patt="^#")
    cat ("Found ", length(comment.lines), " comment.lines\n")
    fix.lines <- fix.lines[-comment.lines]
    translate <- strsplit(fix.lines, split="\\s*:\\s*")
    for (i.fix in seq(along=translate)) {
        clean <- translate[[i.fix]][1]
        dirty <- strsplit (translate[[i.fix]][2], split="\\s*,\\s*")[[1]]
        x[x %in% dirty] <- clean
    }
    return(x)
}


irs.find.org.groups <- function(dat, min.match.words=4,
                                out.file="../groups.txt",
                                typo.file="../edited_typos_1.txt")
{
    clean.names <- irs.fix.typos(dat, typo.file=typo.file)
    sub.names <- with (dat, clean.names[!is.na(Affiliation.Type) & Affiliation.Type == "Subordinate"])
    use.names <- unique(as.character(sub.names))
    use.names <- sub (x=use.names, patt="\\s+INC$", perl=T, repl="")
#    browser()
    use.names <- clean.string (use.names)
#    browser()
    all.words <- strsplit(x=unique(use.names), split="\\s+")
    prefix.words <- lapply (all.words, function (x) x[1:min.match.words])
    prefix.name <- sapply (prefix.words, paste, collapse=" ")
    rv <- split(unique(use.names), factor(prefix.name))
    n.matches <- sapply (rv, length)
    rv <- rv [n.matches >= 2]
    cat ("", file=out.file)
    for (i.prefix in seq(along=names(rv))) {
        group <- rv[[i.prefix]]
        word.split <- strsplit(group, "\\s+")
        n.match <- min.match.words
        n.in.group <- length(group)
        while (1) {
            prefix.cand <- sapply (word.split, function(x)paste(x[1:n.match], collapse=" "))
            n.uniq <- length(unique(prefix.cand))
            if (n.uniq == 1) {
                n.match <- n.match + 1
                use.prefix <- prefix.cand[1]
            }
            else {
                break
            }
        }
        names(rv)[i.prefix] <- use.prefix
        cat (use.prefix, ":", paste(group, collapse=", "), "\n", sep="", file=out.file, append=T)
    }
    return (rv)
}

irs.compute.class.types <- function (dat)
{
    rv <- list()
    rv[["Affiliation.Type"]] <- affil.codes[match(dat$Affiliation.Code,
                                                  as.integer(names(affil.codes)))]
    rv[["Foundation.Type"]] <- foundation.codes[match(as.character(dat$Affiliation.Code),
                                                  names(affil.codes))]
    rv[["Org.Type"]] <- org.codes[match(dat$Organization.Code,
                                        as.integer(names(org.codes)))]
    return(as.data.frame(rv))
}


clean.string <- function (string)
{
    string <- gsub (x=string, patt="\\s+&\\s+", repl=" AND ", perl=T)
    string <- sub (x=string, patt="^\\s+", "")
    string <- sub (x=string, patt="\\s+$", "")
    string <- sub (x=string, patt="\\s+", " ")
    return (string)
}

irs.match.mnn <- function(mnn.file="../Export-MNO-Profiles-351-09-Aug-2013-09-44-45.csv",
                          bmf.file="../eo_mass_all.csv")
{
    mnn <- read.csv (mnn.file, head=T)
    bmf <- mmn.load.exempt.org (bmf.file)
    mnn.org <- as.character(mnn$Organization)
    can.mnn.org <- mnn.canonicalize (mnn.org)
    uniq.bmf <- !duplicated(bmf$Fixed.Typos)
    bmf.org <- as.character(bmf[uniq.bmf, "Fixed.Typos"])
    can.bmf.org <- mnn.canonicalize (bmf.org)
    bmf.match.inds <- match(can.mnn.org, can.bmf.org)
    is.match <- !is.na(bmf.match.inds)
    real.match.inds <- bmf.match.inds[is.match]
    matched <- can.bmf.org[real.match.inds]
    match.counts <- as.integer(table(can.bmf.org)[matched])
    mnn.unmatch.inds <- which(!is.match)
    mnn.match.inds <- which(is.match)
    unmatched <- can.mnn.org[!is.match]
    cands <- list()
    fillers <- c("NEW ENGLAND", "MASSACHUSETTS", "BOSTON")

    for (filler in fillers) {
        key.unmatched <- gsub (x=unmatched, patt=filler, repl="")
        key.bmf <- gsub (can.bmf.org, patt=filler, repl="")
    }
    bmf.zips <- as.character(bmf[uniq.bmf, "Zip.Code"])
    for (ind in mnn.unmatch.inds) {
        mnn.targ <- can.mnn.org[ind]
        if (mnn.targ == "") next
        cand.inds <- agrep(mnn.targ, key.bmf, max.dist=0.1, value=F, fixed=T)
        n.cand.inds <- length(cand.inds)
        if (n.cand.inds > 5 || n.cand.inds == 0) {
            mnn.zip <- as.character(mnn[ind, "ZipCode"])
            cand.inds <- which(bmf.zips == mnn.zip)
        }
        cands[[mnn.org[ind]]] <- bmf.org[cand.inds]
    }
    nomatch <- mnn.unmatch.inds
    mnn.match.names <- as.character(mnn[mnn.match.inds, "Organization"])
    bmf.match.names <- bmf.org[real.match.inds]
    out.mnn <- mnn.match.names
    out.bmf <- bmf.match.names
    out.mnn <- c(out.mnn, as.character(mnn[!is.match, "Organization"]))
    out.bmf <- c(out.bmf, sapply (cands, paste, collapse="; "))
    out.dframe <- data.frame(MNN=out.mnn, BMF=out.bmf)

    rv <- list(out.frame=out.dframe, pairs=data.frame(MNN=mnn.match.names, BMF=bmf.match.names, Count=match.counts),
               cands=cands, matched=matched, unmatched=unmatched)
    return (rv)
}

mnn.canonicalize <- function (str)
{
    str <- clean.string(str)
    str <- toupper(str)
    trans <- matrix (byrow=T, ncol=2,
                     c(
                         "-", " ",
                        "[^A-Z0-9 ]", "",
                       "\\bINC\\b", "",
                       "\\bINCORPORATED\\b", "",
                       "\\bFOUNDATION\\b", "",
                       "\\bCORP\\b", "",
                       "\\bCORPORATION\\b", "",
                       "\\bTV\\b", "TELEVISION",
                       "\\bASSN\\b", "ASSOCIATION",
                       "\\bMA\\b", "MASSACHUSETTS",
                       "\\bMASS\\b", "MASSACHUSETTS",
                       "\\bUSA\\b", "U S A",
                       "\\bA\\b", "",
                       "\\bOF\\b", "",
                       "\\bTHE\\b", ""))
    for (i.trans in 1:nrow(trans)) {
        str <- gsub(x=str, patt=trans[i.trans,1], repl=trans[i.trans,2])
    }
    str <- gsub (x=str, patt="^\\s+", "")
    str <- gsub (x=str, patt="\\s+$", "")
    str <- gsub (x=str, patt="\\s+", "")
    return(str)
}

irs.parse.act.ntee <- function (file)
{
    lines <- readLines(file)
    map.lines <- grep (x=lines, patt="^\\d{3,3}", val=T, perl=T)
    map.list <- strsplit(map.lines, "\\t")
    act.code <- sapply (map.list, function(x)x[1])
    ntee.str <- sapply (map.list, function(x)x[3])
    is.valid.ntee <- grepl (x=ntee.str,patt= "[A-Z][0-9]{1,2}")
    ntee.str <- ifelse(is.valid.ntee, sapply (ntee.str, function (x)substr(x,1,1)), NA)
    rv <- data.frame(Act.Code=act.code, NTEE=ntee.str)
    return(rv)
}

### Function to add new fields to a CSV file
irs.add.fields <- function (in.csv, out.csv=NULL, func, ...)
{
    dat <- read.csv (in.csv, header=T, strip.white=T, colClasses=c
                     ("EIN"="factor",
                      "Group.Exemption.Number"="factor",
                      "Subsection.Code"="factor",
                      "Affiliation.Code"="factor",
                      "Classification.Code"="factor",
                      "Ruling.Date"="factor",
                      "Tax.Period"="factor",
                      "Advanced.Ruling.Expiration.Date"="factor",
                      "Deductibility.Code"="factor",
                      "Foundation.Code"="factor",
                      "Activity.Code"="factor",
                      "Asset.Code"="factor",
                      "Income.Code"="factor",
                      "Organization.Code"="factor",
                      "Exempt.Organization.Status.Code"="factor",
                      "Blank"=NULL,
                      "PF.Filing.Requirement.Code"="factor")
                     )
    add.cols <- do.call(func, list(dat=dat, ...))
    rv <- data.frame(dat, add.cols)
    if (!is.null(out.csv)) {
        write.csv(rv, out.csv, row.names=F)
    }
    return(rv)
}


mnn.compute.sector <- function (dat,
                                act.ntee.map.file="../activity_ntee_guess_common.txt",
                                ntee.mnn.map.file="../mnn_ntee.csv")
{
    irs.ntee <- substr(as.character(dat$NTEE.Code), 1,1)
    act.code <- as.character(dat$Activity.Code)
    prim.act <- sprintf ("%09d", as.integer(act.code) )
    prim.act <- substr(prim.act, 1,3)
    act.ntee.map <- irs.parse.act.ntee (act.ntee.map.file)
    ind.use.activity <- grep(x=irs.ntee, patt="^\\s*$")
    irs.ntee[ind.use.activity] <- with (act.ntee.map, as.character(NTEE)[match(prim.act[ind.use.activity], Act.Code)])
#    browser()
    ntee.mnn.map <- mnn.parse.ntee(ntee.mnn.map.file)
    sector <- with (ntee.mnn.map, Sector[match(irs.ntee, NTEE)])
    sector.method <- rep(NA, length(sector))
    sector.method[-ind.use.activity] <- "NTEE"
    sector.method[ind.use.activity] <- "Activity"
    sector.method[is.na(sector)] <- NA
    return (data.frame(Sector=sector, Sector.Method=sector.method))
}

mnn.parse.ntee <- function(file)
{
    dat <- read.csv(file, strip.white=T, stringsAsFactors=F)
    code.list <- strsplit (dat$NTEE, split=";", fixed=T)
    codes <- unlist(code.list)
    codes <- gsub(x=codes, patt="\\s+", repl="")
    code.sector <- rep(dat$Sector, sapply (code.list, length))
    return (data.frame(NTEE=codes, Sector=code.sector))
}

irs.compute.c3.designation <- function (dat)
{
    rv <- as.integer(as.character(dat$Subsection.Code))
    rv[rv = 92] <- 3
    rv[rv >= 40] <- NA
    rv [rv == 0] <- NA
    rv <- factor(as.character(rv))
    return (data.frame("Designation.501c"=rv))
}

irs.compute.mnn <- function (dat, mnn.file="../mnn_bmf_matches_esther.csv", ein.file="../mnn_bmf_ein.csv")
{
    jeff <- read.csv (ein.file)
    rv <- rep(NA, nrow(dat))
    inds.in.dat <- match(jeff$EIN, dat$EIN)
    no.match <- is.na(inds.in.dat) | jeff$EIN == ""
    inds.in.jeff <- which (!no.match)
    inds.in.dat <- inds.in.dat[!no.match]
    mnn.name <- as.character(jeff[inds.in.jeff, "MNN"])
    rv[inds.in.dat] <- mnn.name
    nomatch.names <- as.character(jeff[no.match, "MNN"])
    esther <- read.csv (mnn.file)
    esther.mnn <- as.character(esther$MNN)
    esther.bmf <- as.character(esther$BMF)
    irs.bmf <- as.character(dat$Name)
    for (i.nomatch in seq(along=nomatch.names)) {
        mnn.to.match <- nomatch.names[i.nomatch]
        ind.in.esther <- match(mnn.to.match, esther.mnn)
        if (!is.na(ind.in.esther) && esther.bmf[ind.in.esther] != "") {
            ind.in.rv <- match(esther.bmf[ind.in.esther], irs.bmf)
            rv[ind.in.rv] <- mnn.to.match
        }
    }
    return (data.frame(MNN.Name=rv))
}
budget.levels <-c("Under 25k", "25k-75k", "75k-250k", "250k-750k", "750k-2.5m", "2.5m-10m", "10m-25m","25m-50m",
                "50m-100m","100m-200m","200m-500m", "Over 500m")

mnn.compute.budget.level <- function (dat)
{
    breaks <- c(-Inf, 25000, 75000, 250000, 750000, 2500000, 10000000, 25000000, 50000000, 100000000, 200000000, 500000000, Inf)
    levs <- budget.levels
    budget.fields <- c("NCCS_2011_EXPS",
                       "NCCS_2011_P1ADMEXP")
    budget <- rep (NA, nrow(dat))
    for (field in budget.fields) {
        to.fill <- is.na(budget)
        budget[to.fill] <- dat[[field]][to.fill]
    }
    rv <- cut(budget, breaks=breaks, labels=levs, right=F, include=T)
    return(data.frame(NCCS_2011_Budget=budget, NCCS_2011_Budget.Range=rv))
}

mnn.split.set <- function (dat, dev.frac=0.67)
{
    set.seed (5)
    inds <- 1:nrow(dat)
    strat.inds <- split(inds, !is.na(dat$MNN.Name))
    all.dev.inds <- all.test.inds <- integer(0)
    for (i.strat in seq(along=strat.inds)) {
        inds <- strat.inds[[i.strat]]
        dev.size <- dev.frac * length(inds)
        dev.inds <- sample(inds, dev.size)
        test.inds <- setdiff(inds, dev.inds)
        all.dev.inds <- c(all.dev.inds, dev.inds)
        all.test.inds <- c(all.test.inds, test.inds)
    }
    sets <- list(DEV=dat[all.dev.inds,], TEST=dat[all.test.inds,])
    for (i.set in seq(along=sets)) {
        set.name <- names(sets)[i.set]
        set.dat <- sets[[i.set]]
        set.dat <- set.dat[order(set.dat$Name),]
        sets[[i.set]] <- set.dat
    }
    return(sets)
}

## Compute region from
mnn.compute.region <- function (dat, mnn.file="../mnn_regions_by_town.txt", zip.file="../mass_zips.csv")
{
    load.sp <- require("sp")
    if (!load.sp) {
        warning ("Will notimpute missing regions from nearest neighbors")
    }

    org.city <- as.character(dat$City.Clean)
    items <- scan (mnn.file, what="", quiet=T)
    region.inds <- grep(patt=":", items)
    region.names <- sub(x=items[region.inds], patt=":", repl="")
    inds <- seq(along=items)
    region.cat <- as.character(cut (inds[-region.inds], c(region.inds, Inf), label=region.names))
    mnn.city.names <- toupper(items[-region.inds])
    org.region <- region.cat[match(org.city, mnn.city.names)]
    is.na.region <- is.na(org.region)
    org.zip <- substring(as.character(dat$Zip.Code.Clean), 1, 5)
    city.zip.dat <- read.csv (zip.file)
    city.zip.keep <- subset(city.zip.dat, City %in% mnn.city.names)
    city.zip <- toupper(as.character(city.zip.keep$City))
    zip.zip <- sprintf ("%05d", city.zip.keep$Zipcode)
    org.city[is.na.region] <- city.zip[match(org.zip[is.na.region], zip.zip)]
#    browser()
    org.region[is.na.region] <- region.cat[match(org.city[is.na.region], mnn.city.names)]
    is.na.region <- is.na (org.region)
    org.city[is.na.region] <- sub(x=dat[is.na.region, "City.Clean"], patt="WEST|EAST|NORTH|SOUTH", repl="")
    org.city[is.na.region] <- sub(x=org.city[is.na.region], patt="^\\s+", repl="")
#    browser()
    org.region[is.na.region] <- region.cat[match(org.city[is.na.region], mnn.city.names)]
    is.na.region <- is.na(org.region)
    km.from.missing <- spDists(as.matrix(dat[is.na.region, c("Longitude", "Latitude")]),
                               as.matrix(dat[!is.na.region, c("Longitude", "Latitude")]), longlat=T)
    nearest <- apply (km.from.missing, 1, which.min)
    org.region[is.na.region] <- org.region[!is.na.region][nearest]
#    browser()
    return (data.frame(Region=org.region))
}

mnn.discrete.dist <- function (dat, fact.name, xlab.val, min.budget=25000)
{
    cat ("Nrows before filtering = ", nrow(dat), "\n")
    dat <- subset(dat, !is.na(NCCS_2011_Budget) &
                  NCCS_2011_Budget >= min.budget & Designation.501c %in% c(3,4))
    cat ("Nrows after filtering = ", nrow(dat), "\n")
    is.mnn <- !(is.na(dat$MNN.Name))
    dat <- within (dat, NCCS_2011_Budget.Range <- factor(NCCS_2011_Budget.Range, levels=budget.levels))
    dat <- within (dat, MNN.Member <- ifelse(is.mnn, "MNN Member", "MNN Non-Member"))
    dat <- within (dat, mnn.weight <- ifelse(is.mnn, 100/sum(is.mnn), 100/sum(!is.mnn)))
    p <- ggplot(data=dat) + ylab("Percent of organizations")
    bar <- geom_bar (pos="dodge", aes(y=..count.., fill=MNN.Member, weight=mnn.weight), width=.6)
    title <- paste("Distribution of ", xlab.val, " by MNN membership status for c3 and c4 orgs > 25k budget")
    fp <- p + bar+ aes_string(x=fact.name) + xlab(xlab.val) + labs(title=title)
    attr(fp, "bar.stats") <- bar
    return(fp)
}

mnn.load.targ.dat <- function (file, min.budget=50000)
{
    dat <- read.csv (file, header=T, colClasses=c
                     ("EIN"="factor",
                      "Group.Exemption.Number"="factor",
                      "Subsection.Code"="factor",
                      "Affiliation.Code"="factor",
                      "Classification.Code"="factor",
                      "Ruling.Date"="factor",
                      "Tax.Period"="factor",
                      "Advanced.Ruling.Expiration.Date"="factor",
                      "Deductibility.Code"="factor",
                      "Foundation.Code"="factor",
                      "Activity.Code"="factor",
                      "Asset.Code"="factor",
                      "Income.Code"="factor",
                      "Organization.Code"="factor",
                      "Exempt.Organization.Status.Code"="factor",
                      "Blank"=NULL,
                      "PF.Filing.Requirement.Code"="factor"))
    dat <- subset(dat, !is.na(NCCS_2011_Budget) & NCCS_2011_Budget >= min.budget & Sector != "Religious Organizations" & Designation.501c %in% c(3,4))
    dat <- within(dat, MNN.Status <- factor(ifelse(is.na(MNN.Name),
                                                   "Non-Member", "MNN Member"), levels=c("Non-Member", "MNN Member")))
    return(dat)
}

mnn.plot.geog <- function (dat, facet.by.sector=T, ...)
{
    p <- ggplot(data=dat, aes(x=Longitude, y=Latitude))  +
        borders("county", "massachusetts") +
            geom_point(aes(color=MNN.Status, size=MNN.Status, shape=MNN.Status, alpha=MNN.Status)) +
                scale_colour_manual(values=c("blue", "red"))  +
                    scale_shape_manual(values=c(1, 20)) + scale_size_manual(values=c(1,2)) + scale_alpha_manual(values=c(.2,1))
    if (facet.by.sector) {
        p <- p + facet_wrap(~ Sector, ncol=3)
    }
    return(p)
}

mnn.compare.region.class <- function (dat, zip.file="../mass_zips.csv")
{
    dat <- within (dat, Region <- factor(Region, levels=names(rev(top(Region, 30)))))
    dat <- within (dat, New.Region <- factor(New.Region, levels=names(rev(top(New.Region, 30)))))
    city.zip.dat <- read.csv (zip.file)
    city.zip <- toupper(as.character(city.zip.dat$City))
    zip.zip <- sprintf ("%05d", city.zip.dat$Zipcode)
    inner.mw.cities <- c("WALTHAM", "NEWTON", "LEXINGTON")
    inner.zip.list <- list()
    for (inn in inner.mw.cities) {
        inner.zip <- zip.zip[city.zip == inn]
        inner.zip.list[[inn]] <- inner.zip
    }
    print (inner.zip.list)
    all.inner.mw.zips <- unlist(inner.zip.list)
    Proposed.Region <- as.character(dat$New.Region)
    zip5 <- substr(as.character(dat$Zip.Code.Clean), 1,5)
    Proposed.Region[zip5 %in% all.inner.mw.zips] <- "Inner Metrowest"
    Proposed.Region[Proposed.Region == "Metrowest"] <- "Outer Metrowest"
    Proposed.Region[Proposed.Region %in% c("Boston West", "Boston South")] <- "Boston Southwest"
    Proposed.Region[Proposed.Region %in% c("Allston Area", "Back Bay Area")] <- "Boston North"
    Proposed.Region <- factor(Proposed.Region, levels=names(rev(top(Proposed.Region, 30))))
    dat[["Proposed.Region"]] <- Proposed.Region
    dat <- within (dat,  {
        Super.Region <- rep(NA, nrow(dat))
        Super.Region[Region == "Boston"] <- "Boston"
        Super.Region[Region == "Metrowest"] <- "Metrowest"
        Super.Region[is.na(Region)] <- "Other"
        Super.Region <- factor(Super.Region, levels=c("Boston", "Metrowest", "Other"))
    })
    ggp <- list()
    schemes <- c("Region", "New.Region", "Proposed.Region")
    titles <- c("Regional distribution", "Subregional distribution: proposal 1", "Subregional distribution: proposal 2")
    for (i.scheme in seq(along=schemes)) {
        scheme <- schemes[i.scheme]
        ggp[[i.scheme]] <- ggplot(data=dat, aes_string(x=scheme)) + geom_bar(aes(y=..count.., fill=Super.Region)) +
            xlab ("Region") + ylab("Number of candidate non-profits") + coord_flip() +
                labs(title=titles[i.scheme])
    }
    gg.mult.plot.down (ggp)
}




gg.mult.plot.down <- function (p.list)
{
    n.plots <- length(p.list)
    vplayout <- function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
    grid.newpage()
    pushViewport(viewport(layout=grid.layout(n.plots,1)))
    for (i.plot in seq(along=p.list)) {
        print(p.list[[i.plot]], vp=vplayout(i.plot, 1))
    }
}

mnn.compute.subregions <- function (dat, zip.file="../mass_zips.csv")
{
    city.zip.dat <- read.csv (zip.file)
    city.zip <- toupper(as.character(city.zip.dat$City))
    zip.zip <- sprintf ("%05d", city.zip.dat$Zipcode)
    zip5 <- substr(as.character(dat$Zip.Code.Clean), 1,5)
## Woburn ia classifed by MNN as being Northeast. Esther had put it in Boston Region and so was classified
## as North of Boston in Kathy's recoding. Have to put it back to Woburn
    Subregion.Prop.1 <- dat$New.Region
    Subregion.Prop.1[dat$City.Clean == "CHESTNUT HILL" || zip5 == "02467"] <- "Inner Suburbs"
    Region <- dat$Region
    Region[Subregion.Prop.1 == "Inner Suburbs"] <- "Boston"
    woburn.zip <- zip.zip[city.zip == "WOBURN"]
    is.woburn <- which (zip5 %in% woburn.zip)
    Subregion.Prop.1[is.woburn] <- "Northeast"
    ## Fix Chestnut hill issue
    brookline.zip <- zip.zip[city.zip == "BROOKLINE"]
    is.brookline <- which (zip5 %in% brookline.zip)
#    Subregion.Prop.1[is.brookline] <- "Inner Suburbs"
    inner.mw.cities <- c("WALTHAM", "NEWTON", "LEXINGTON")
    inner.zip.list <- list()
    for (inn in inner.mw.cities) {
        inner.zip <- zip.zip[city.zip == inn]
        inner.zip.list[[inn]] <- inner.zip
    }
    all.inner.mw.zips <- unlist(inner.zip.list)
    Subregion.Prop.2 <- as.character(Subregion.Prop.1)
    Subregion.Prop.2[zip5 %in% all.inner.mw.zips & !(dat$City %in% c("CHESTNUT HILL", "BROOKLINE", "BOSTON"))] <- "Inner Metrowest"
    Subregion.Prop.2[Subregion.Prop.2 == "Metrowest"] <- "Outer Metrowest"
    Subregion.Prop.2[Subregion.Prop.2 %in% c("Boston West", "Boston South")] <- "Boston Southwest"
    Subregion.Prop.2[Subregion.Prop.2 %in% c("Allston Area", "Back Bay Area")] <- "Boston North"
    Subregion.Prop.2[Subregion.Prop.2 == "North of Boston"] <- "North Shore"
    return (data.frame (Region=Region, Subregion.1=Subregion.Prop.1, Subregion.2=Subregion.Prop.2))
}

mnn.compute.mnn.status <- function (dat)
{
    return (data.frame(MNN.Status=!is.na(dat$MNN.Name)))
}

