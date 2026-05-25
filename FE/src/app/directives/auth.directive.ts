import { Directive, inject, Input, OnInit, TemplateRef, ViewContainerRef } from '@angular/core';
import { AuthService } from '@services/auth.service';
import { AuthRole } from '@enums/auth-role';

/**
 * Directive that displays content based on the user's role
 */
@Directive({
  standalone: true,
  selector: '[appHasRole]',
})
export class HasRoleDirective implements OnInit {
  @Input('appHasRole') roles: AuthRole[] | undefined;

  private readonly authService = inject(AuthService);
  private readonly templateRef = inject(TemplateRef);
  private readonly viewContainer = inject(ViewContainerRef);

  ngOnInit(): void {
    this.checkAndRenderView();
  }

  private checkAndRenderView(): void {
    if (this.authService.hasRole(this.roles)) {
      this.viewContainer.createEmbeddedView(this.templateRef);
    } else {
      this.viewContainer.clear();
    }
  }
}
