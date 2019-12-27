import { Component, OnInit, ViewChild } from '@angular/core';

// import { NgTerminal } from 'NgterminalModule';

// import { NgTerminal } from '@angular/material/NgTerminal';
import { NgTerminal } from 'ng-terminal';
import { Terminal } from 'xterm';
@Component({
  selector: 'app-terminal',
  templateUrl: './terminal.component.html',
  styleUrls: ['./terminal.component.scss']
})
export class TerminalComponent implements OnInit {

  @ViewChild('term', { static: true }) child: NgTerminal;
  obj = {} 
  
  constructor() {
    this.obj = new Terminal(
      {

      }
    );
  }

  ngOnInit() {
    
  }
  
  ngAfterViewInit(){
  this.child.keyEventInput.subscribe(e => {
    console.log('keyboard event:' + e.domEvent.keyCode + ', ' + e.key);

    const ev = e.domEvent;
    const printable = !ev.altKey && !ev.ctrlKey && !ev.metaKey;

    if (ev.keyCode === 13) {
      this.child.write('\r\neliot@sample$ ');
    } else if (ev.keyCode === 8) {
      // Do not delete the prompt
      if (this.child.underlying.buffer.cursorX > 14) {
        this.child.write('\b \b');
      }
    } else if (printable) {
      this.child.write(e.key);
    }

    
  })
  }
}
