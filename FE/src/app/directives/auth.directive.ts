import { Directive, Input, OnInit, TemplateRef, ViewContainerRef } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { AuthRole } from '../types';

/**
 * Directive that displays content based on the user's role
 */
@Directive({
  standalone: true,
  selector: '[appHasRole]',
})
export class HasRoleDirective implements OnInit {
  @Input('appHasRole') role: AuthRole | undefined;

  constructor(
    private authService: AuthService,
    private templateRef: TemplateRef<any>,
    private viewContainer: ViewContainerRef,
  ) {}

  ngOnInit(): void {
    this.checkAndRenderView();
  }

  private checkAndRenderView(): void {
    if (this.authService.hasRole(this.role)) {
      console.log('Permission granted');
      this.viewContainer.createEmbeddedView(this.templateRef);
    } else {
      console.log('No permission');
      this.viewContainer.clear();
    }
  }
}
