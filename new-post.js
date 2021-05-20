'use strict';

const path = require('path');
const fs = require("fs");
const execSync = require('child_process').execSync;

// レイアウト
const LAYOUT = 'page';
// 新しいポストを作成するパス
const OUTPUT_PATH = ['_source', '_posts'];
// 拡張子
const EXTENSION = '.md';
// 新しいPostを開くエディターのパス
const EDITOR = 'code';
// ファイル名に使用できない文字 '!"#$%&()*,/:;?@[]^`{|}\+<=>
const INVALID_FILENAME_CHAR = /[ '!"#\$%&\(\)\*,\/:;\?@\[\]\^`\{\|\}\\\+<=>]/g;

//------------------------------------------------------------------------------
// 日付文字列を作成
//------------------------------------------------------------------------------
function createDateString(date) {
    let YYYY = date.getFullYear();
    let MM = zeroFill(date.getMonth() + 1, 2);
    let DD = zeroFill(date.getDate(), 2);

    return `${YYYY}-${MM}-${DD}`;
}

//------------------------------------------------------------------------------
// 時刻文字列を作成
//------------------------------------------------------------------------------
function createTimeString(date) {
    let hh = zeroFill(date.getHours(), 2);
    let mm = zeroFill(date.getMinutes(), 2);
    let ss = zeroFill(date.getSeconds(), 2);

    return `${hh}:${mm}:${ss}`;
}

//------------------------------------------------------------------------------
// YAML front matterを作成
//------------------------------------------------------------------------------
function createYAMLFrontMatter(date, title) {
    let dateTimeString = createDateString(date) + ' ' + createTimeString(date);

    return (
`---
layout: ${LAYOUT}
title: ${title}
date: ${dateTimeString} +0900
category: blog
tags:
---

`
    );
}

//-----------------------------------------------------------------------------
// ゼロ埋め
//-----------------------------------------------------------------------------
function zeroFill(num, digit) {
    return num.toString().padStart(digit, '0');
}

//-----------------------------------------------------------------------------
// ファイル名を作成
//-----------------------------------------------------------------------------
function createFileName(date, title) {
    let fileName = title;

    fileName = fileName.replace(INVALID_FILENAME_CHAR, '-').toLowerCase();
    fileName = createDateString(date) + '-' + fileName + EXTENSION;

    return fileName;
}

//-----------------------------------------------------------------------------
// 新しいPostを作成
//-----------------------------------------------------------------------------
function createNewPost(title) {
    let today = new Date();
    let frontMatter = createYAMLFrontMatter(today, title);
    let fileName = createFileName(today, title);
    let filePath = path.join(__dirname, ...OUTPUT_PATH, fileName);

    fs.writeFileSync(filePath, frontMatter);

    return filePath;
}

//-----------------------------------------------------------------------------
// メイン
//-----------------------------------------------------------------------------
function main() {
    const readline = require('readline').createInterface({
        input: process.stdin,
        output: process.stdout
    });

    // カレントディレクトリをスクリプトのあるディレクトリへ変更
    process.chdir(__dirname);

    readline.question('タイトルを入力して下さい: ', title => {
        readline.close();

        let filePath = createNewPost(title);
        execSync(`${EDITOR} ${filePath}`);
    });
}

main();
