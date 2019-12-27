import { Component, OnInit } from '@angular/core';
import { ToolbarService } from './../toolbar/toolbar.service';

@Component({
  selector: 'app-description',
  templateUrl: './description.component.html',
  styleUrls: ['./description.component.scss']
})
export class DescriptionComponent implements OnInit {
  
  constructor(public toolbarService: ToolbarService) { }

  ngOnInit() {
    this.toolbarService.show();
  }

}
